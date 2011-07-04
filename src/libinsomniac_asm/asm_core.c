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

/* Entry point for the assembler. code_ref is assumed to be attached
   to the gc. */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref) {
    yyscan_t scanner = 0;
    op_type token = 0;
    buffer_type *buf = 0;
    size_t length = 0;
    
    
    gc_register_root(gc, &buf);

    /* create an output buffer */
    buf = buffer_create(gc);

    yylex_init(&scanner);


    /* set the scanners input */
    yy_scan_string(str, scanner);

    /* match until there is nothing left to match */
    while((token = yylex(scanner)) != END_OF_FILE) {
        printf("Found token %i:'%s'\n", token, get_text(scanner));
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

        case OP_CONS:
            EMIT_CONS(buf);
            break;

        case OP_MAKE_SYMBOL:
            EMIT_MAKE_SYMBOL(buf);
            break;

        case OP_MAKE_VECTOR:
            EMIT_MAKE_VECTOR(buf);
            break;

        case OP_VECTOR_SET:
            EMIT_VECTOR_SET(buf);
            break;

        case OP_VECTOR_REF:
            EMIT_VECTOR_REF(buf);
            break;

        case OP_JMP:
            /* TODO: */
            break;
            
        case OP_JNF:
            /* TODO: */
            break;

        case OP_DUP_REF:
            EMIT_DUP_REF(buf);
            break;

        case OP_SWAP:
            EMIT_SWAP(buf);
            break;


        case OP_OUTPUT:
            EMIT_OUTPUT(buf);
            break;                

        default:
            printf("Undefined instruction '%s'\n", get_text(scanner));
            break;
        }
    }

    yylex_destroy(scanner);


    /* build a code_ref */
    length = buffer_size(buf);
    *code_ref = gc_alloc(gc, 0, length);
    length = buffer_read(buf, code_ref, length);

    gc_unregister_root(gc, &buf);

    return length;
}
