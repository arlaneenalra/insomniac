#include "asm_internal.h"
#include "lexer.h"

#include <assert.h>

/* Add an element in the debug chain if one is needed. */
void push_debug(gc_type *gc, debug_info_type *debug, char *file, vm_int line, vm_int column, vm_int addr) {
    debug_state_type *new = 0; 
    debug_state_type *tail = debug->tail;

    /* check if an update is needed. */ 
    if (tail && tail->file && strcmp(tail->file, file) == 0 && tail->line == line && tail->column == column) {
        return;
    }
 
    gc_register_root(gc, (void **)&new);

    /* Allocate a new record. */
    gc_alloc_type(gc, 0, get_debug_state_def(gc), (void **)&new);

    new->file = file;
    new->line = line;
    new->column = column;
    new->next = 0;

    /* no record */
    if (!tail) {
        debug->tail = debug->head = new;
    } else {
        debug->tail->next = new;
        debug->tail = new;
    }

    gc_unregister_root(gc, (void **)&new);
}

/* parse the current line or column number. */
int get_debug_num(gc_type *gc, yyscan_t *scanner) {
    int token = 0;
    vm_int i = 0;

    token = yyasmlex(scanner);
    if (token != OP_LIT_FIXNUM) {
        printf(".ln requires a number.\n");
        assert(0);
    }

    return strtoq(get_text(scanner), 0, 0);
}

/* parse a string out of the token stream for debugging info */
void add_debug_file(gc_type *gc, yyscan_t *scanner, debug_info_type *debug, vm_int addr) {
    int token = 0;

    char *filename = 0;
    int line = 0;
    int column = 0;

    char *value = 0;

    hashtable_type *files = debug->files;

    gc_register_root(gc, (void **)&value);

    /* get the next token */
    token = yyasmlex(scanner);

    if (token != STRING_START_TOKEN) {
        assert(0);
    }

    token = yyasmlex(scanner);

    /* do we have a string body? */
    if (token == OP_LIT_STRING) {
       
        /* Copy the file name into a gc allocated string. */
        filename = get_text(scanner);
    
        /* grab the next token */
        token = yyasmlex(scanner);
    }
    if (token != STRING_END_TOKEN) {
        assert(0);
    }
    
    if (!hash_get(files, filename, (void **)&value)) {
        gc_make_substring(gc, filename, &value, strlen(filename) - 1);
        hash_set(files, value, value);
    } 
  
    line = get_debug_num(gc, scanner);
    column = get_debug_num(gc, scanner);

    push_debug(gc, debug, value, line, column, addr);
    gc_unregister_root(gc, (void **)&value);
}

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

    if (strcmp(str, "newline") == 0) {
        c = '\n';

    } else if (strcmp(str, "space") == 0) {
        c = ' ';

    } else if (strcmp(str, "eof") == 0) {
        c = -1;

    } else if (*str == 'x' && strlen(str) > 1) { /* Hex encoded charater */
        c = strtoul(str + 1, 0, 16);
    }

    EMIT_LIT_CHAR(buf, c);
}

/* assemble a string literal */
void asm_lit_string(buffer_type *buf, yyscan_t *scanner) {
    int empty = 1;
    int token = 0;

    /* get the next token */
    token = yyasmlex(scanner);

    /* do we have a string body? */
    if (token == OP_LIT_STRING) {
        EMIT_LIT_STRING(buf, get_text(scanner));
        empty = 0;

        /* grab the next token */
        token = yyasmlex(scanner);
    }

    /* do we have an empty string? */
    if (token == STRING_END_TOKEN) {
        if (empty) {
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
void asm_label(gc_type *gc, buffer_type *buf, hashtable_type *labels, char *str) {
    vm_int *addr = 0;
    char *key = 0;

    gc_register_root(gc, (void **)&key);
    gc_register_root(gc, (void **)&addr);

    /* defensively copy the label name */
    gc_alloc(gc, 0, strlen(str) + 1, (void **)&key);
    strcpy(key, str);

    /* save location */
    gc_alloc(gc, 0, sizeof(vm_int), (void **)&addr);
    *addr = buffer_size(buf);

    hash_set(labels, key, addr);

    gc_unregister_root(gc, (void **)&key);
    gc_unregister_root(gc, (void **)&addr);
}

void asm_jump(gc_type *gc, buffer_type *buf, yyscan_t *scanner, jump_type **jump_list) {

    static int init = 0;
    static gc_type_def jump_def = 0;
    jump_type *jump = 0;
    char *label = 0;

    /* TODO: This is a hack */
    if (!init) {
        init = 1;
        jump_def = gc_register_type(gc, sizeof(jump_type));

        gc_register_pointer(gc, jump_def, offsetof(jump_type, label));

        gc_register_pointer(gc, jump_def, offsetof(jump_type, next));
    }

    gc_register_root(gc, (void **)&jump);

    /* allocate a new jump */
    gc_alloc_type(gc, 0, jump_def, (void **)&jump);

    /* save location of jump addr field */
    jump->addr = buffer_size(buf);

    /* save the line number for this jump */
    jump->lineno = yyasmget_lineno(scanner);

    /* make sure we have a label */
    if (yyasmlex(scanner) != LABEL_TOKEN) {
        assert(0);
    }

    /* save a copy of the label */
    label = get_text(scanner);
    gc_alloc(gc, 0, strlen(label) + 1, (void **)&(jump->label));
    strcpy(jump->label, label);

    /* put this jump at the head of the
       list */
    jump->next = *jump_list;
    *jump_list = jump;

    gc_unregister_root(gc, (void **)&jump);

    /* Make sure we have space to write target */
    EMIT(buf, INT_64(0), 8);
}

void rewrite_jumps(uint8_t *code_ref, jump_type *jump_list, hashtable_type *labels) {
    vm_int target = 0;
    vm_int *label_addr = 0;

    /* rewrite jumps */
    while (jump_list) {

        /* look up label */
        if (!hash_get(labels, jump_list->label, (void **)&label_addr)) {
            printf(
                "Undefined jump to '%s' @ %" PRIi64 " on line %" PRIi64 "\n",
                jump_list->label, jump_list->addr, jump_list->lineno);
            assert(0);
        }

        /* convert to relative address */
        target = *label_addr - jump_list->addr;
        target -= 8; /* adjust for addr field */

        /* get bytes, there should be 8 */
        uint8_t addr[] = {INT_64(target)};

        /* write bytes into code_ref */
        for (int i = 0; i < 8; i++) {
            code_ref[jump_list->addr + i] = addr[i];
        }

        jump_list = jump_list->next;
    }
}

/* Entry point for the assembler. code_ref is assumed to be attached
   to the gc. */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref, debug_info_type **debug) {
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
    buffer_create(gc, &buf);

    hash_create_string(gc, &labels);

    /* Check for a debug pointer. */
    if (debug) {
        gc_alloc_type(gc, 0, get_debug_info_def(gc), (void **)debug);

        hash_create_string(gc, &((*debug)->files));
        push_debug(gc, *debug, 0, 0, 0, 0);
    }

    yyasmlex_init(&scanner);

    /* set the scanners input */
    yyasm_scan_string(str, scanner);

    /* match until there is nothing left to match */
    while ((token = yyasmlex(scanner)) != END_OF_FILE) {

        /* Handle individual tokens */
        switch ((int)token) {
            case OP_LIT_FIXNUM:
                asm_lit_fixnum(buf, scanner);
                break;

            case OP_LIT_CHAR:
                asm_lit_char(buf, scanner);
                break;

            case STRING_START_TOKEN:
                EMIT(buf, OP_LIT_STRING, 1);
                asm_lit_string(buf, scanner);
                break;

            case SYMBOL_START_TOKEN:
                EMIT(buf, OP_LIT_SYMBOL, 1);
                asm_lit_string(buf, scanner);
                break;

            case OP_JMP:
            case OP_JNF:
            case OP_CALL:
            case OP_PROC:
            case OP_CONTINUE:
                EMIT(buf, token, 1); /* emit the jump operation */
                asm_jump(gc, buf, scanner, &jump_list);
                break;

            case LABEL_TOKEN:
                asm_label(gc, buf, labels, get_text(scanner));
                break;

            case DIRECTIVE_FILE:
                /* Update the current file. */
                if (debug) {
                    add_debug_file(gc, scanner, *debug, buffer_size(buf));
                }                    
                break;

            default:
                /* All instructions not defined otherwise, are their token.
                   But there are things that can be returned as a token, that
                   are not an instruction. So we have to constrain things to
                   the correct range. */
                if (token < OP_MAX_INS) {
                    EMIT(buf, token, 1);
                }
                break;
        }
    }

    yyasmlex_destroy(scanner);

    /* build a code_ref */
    length = buffer_size(buf);
    gc_alloc(gc, 0, length, (void **)code_ref);
    length = buffer_read(buf, *code_ref, length);

    /* replace jump address fields */
    rewrite_jumps(*code_ref, jump_list, labels);

    gc_unregister_root(gc, (void **)&jump_list);
    gc_unregister_root(gc, &labels);
    gc_unregister_root(gc, &buf);

    return length;
}
