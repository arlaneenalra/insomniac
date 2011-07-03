#include "asm_internal.h"
#include "lexer.h"

/* assmble a litteral fix num */
void asm_fixnum(buffer_type *buf, yyscan_t *scanner) {
    vm_int i = 0;
    
    i = strtoq(get_text(scanner), 0, 0);
    EMIT_LIT_FIXNUM(buf, i);
}

/* Entry point for the assembler. code_ref is assumed to be attached
   to the gc. */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref) {
    yyscan_t scanner = 0;
    token_type token = 0;
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
        case NUM_TOKEN:
            asm_fixnum(buf, scanner);
            break;

        case TRUE_TOKEN:
            EMIT_LIT_TRUE(buf);
            break;
            
        case FALSE_TOKEN:
            EMIT_LIT_FALSE(buf);
            break;

        case OUT_TOKEN:
            EMIT_OUTPUT(buf);
            break;

        case JNF_TOKEN:
            EMIT_JNF(buf, 1);
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
