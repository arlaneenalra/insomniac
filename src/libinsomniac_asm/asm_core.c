#include "asm_internal.h"
#include "lexer.h"

#include <assert.h>

/* assmble a litteral fix num */
void asm_lit_fixnum(buffer_type *buf, yyscan_t *scanner) {
    vm_int i = 0;
    
    i = strtoq(get_text(scanner), 0, 0);
    EMIT_LIT_FIXNUM(buf, i);
}

/* assemble a character */
void asm_lit_char(buffer_type *buf, yyscan_t *scanner) {
    char *str = 0;
    vm_char c = 0;

    str = get_text(scanner);
    c = *str; 

    if(strcmp(str, "newline")==0) {
	c = '\n';

    } else if(strcmp(str, "space")==0) {
	c = ' ';

    } else if(*str=='x') { /* Hex encoded charater */
	c = strtoul(str+1, 0, 16);
    }

    EMIT_LIT_CHAR(buf, c);
}

/* assemble a string literal */
void asm_lit_string(buffer_type *buf, yyscan_t *scanner) {
    int empty = 1;
    op_type token = 0;
    
    /* get the next token */
    token = yylex(scanner);
    
    /* do we have a string body? */
    if (token == OP_LIT_STRING) {
        EMIT_LIT_STRING(buf, get_text(scanner));
        empty = 0;

        /* grab the next token */
        token = yylex(scanner);
    }

    /* do we have an empty string? */
    if(token == STRING_END_TOKEN) {
        if(empty) {
            EMIT_LIT_STRING(buf, "");
        }
        return;
    }

    printf("Not recognized token :%i\n", token);

    /* syntax error */
    assert(0);
}

/* Save this label and its location in memory for latter
 lookup */
void asm_label(gc_type *gc, buffer_type *buf, 
               hashtable_type *labels, char *str) {
    vm_int *addr = 0;
    char *key = 0;

    gc_register_root(gc, (void**)&key);
    gc_register_root(gc, (void**)&addr);

    /* defensively copy the label name */
    key = gc_alloc(gc, 0, strlen(str)+1);
    strcpy(key, str);

    /* save location */
    addr = gc_alloc(gc, 0, sizeof(vm_int));
    *addr = buffer_size(buf);

    hash_set(labels, key, addr);

    gc_unregister_root(gc, (void**)&key);
    gc_unregister_root(gc, (void**)&addr);

}

void asm_jump(gc_type *gc, buffer_type *buf,
              yyscan_t *scanner, jump_type **jump_list) {

    static int init = 0;
    static gc_type_def jump_def = 0;
    jump_type *jump = 0;
    char *label = 0;

    /* TODO: This is a hack */
    if(!init) {
        init = 1;
        jump_def = gc_register_type(gc, sizeof(jump_type));
        
        gc_register_pointer(gc, jump_def, offsetof(jump_type, label));
        
        gc_register_pointer(gc, jump_def, offsetof(jump_type, next)); 
    }

    gc_register_root(gc, (void **)&jump);

    /* allocate a new jump */
    jump = gc_alloc_type(gc, 0, jump_def);

    /* save location of jump addr field */
    jump->addr = buffer_size(buf);

    /* make sure we have a label */
    if(yylex(scanner) != LABEL_TOKEN) {
        assert(0);
    }

    /* save a copy of the label */
    label = get_text(scanner);
    jump->label = gc_alloc(gc, 0, strlen(label)+1);
    strcpy(jump->label, label);
    
    /* put this jump at the head of the
       list */
    jump->next = *jump_list;
    *jump_list = jump;
    
    gc_unregister_root(gc, (void **)&jump);

    /* Make sure we have space to write target */
    EMIT(buf, INT_64(0),8);

}

void rewrite_jumps(uint8_t *code_ref, jump_type *jump_list,
                   hashtable_type *labels) {
    vm_int target = 0;
    vm_int *label_addr = 0;

        /* rewrite jumps */
    while(jump_list) {


        /* look up label */
        if(!hash_get(labels, jump_list->label, (void **)&label_addr)) {
            printf("Undefined jump to '%s' @ %" PRIi64 "\n", jump_list->label, jump_list->addr);
            assert(0);
        }

        /* convert to relative address */
        target = *label_addr - jump_list->addr;
        target -= 8; /* adjust for addr field */


        /* get bytes, there should be 8 */
        uint8_t addr[] = { INT_64(target)};
        
        /* write bytes into code_ref */
        for(int i=0; i < 8; i++) {
            code_ref[jump_list->addr + i] = addr[i];
        }
        
        jump_list = jump_list->next;
    }

}

/* Entry point for the assembler. code_ref is assumed to be attached
   to the gc. */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref) {
    yyscan_t scanner = 0;
    op_type token = 0;
    buffer_type *buf = 0;
    hashtable_type *labels = 0;
    jump_type *jump_list = 0;
    size_t length = 0;
    
    
    gc_register_root(gc, &buf);
    gc_register_root(gc, &labels);
    gc_register_root(gc, (void **)&jump_list);

    /* create an output buffer */
    buf = buffer_create(gc);
    labels = hash_create_string(gc);

    yylex_init(&scanner);


    /* set the scanners input */
    yy_scan_string(str, scanner);

    /* match until there is nothing left to match */
    while((token = yylex(scanner)) != END_OF_FILE) {

        /* Handle individual tokens */
        switch(token) {
        case OP_NOP:
            EMIT_NOP(buf);
            break;

        case OP_LIT_EMPTY:
            EMIT_LIT_EMPTY(buf);
            break;

        case OP_LIT_FIXNUM:
            asm_lit_fixnum(buf, scanner);
            break;

        case OP_LIT_CHAR:
            asm_lit_char(buf, scanner);
            break;

        case OP_LIT_TRUE:
            EMIT_LIT_TRUE(buf);
            break;
            
        case OP_LIT_FALSE:
            EMIT_LIT_FALSE(buf);
            break;

        case STRING_START_TOKEN:
            asm_lit_string(buf, scanner);
            break;

        case OP_JMP:            
        case OP_JNF:
            EMIT(buf, token, 1); /* emit the jump operation */
            asm_jump(gc, buf, scanner, &jump_list);
            break;                

        case LABEL_TOKEN:
            asm_label(gc, buf, labels, get_text(scanner));
            break;

            /* All otherwise not defined tokens are
               their opcode */
        default:
            EMIT(buf, token, 1);
            break;

        }
    }

    yylex_destroy(scanner);


    /* build a code_ref */
    length = buffer_size(buf);
    *code_ref = gc_alloc(gc, 0, length);
    length = buffer_read(buf, *code_ref, length);

    /* replace jump address fields */
    rewrite_jumps(*code_ref, jump_list, labels);

    gc_unregister_root(gc, &buf);
    gc_unregister_root(gc, &labels);
    gc_unregister_root(gc, (void **)&jump_list);

    return length;
}
