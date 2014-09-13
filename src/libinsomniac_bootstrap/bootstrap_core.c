
#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#include <stdio.h>

/* Emit a boolean into our code stream */
void emit_bool(compiler_core_type *compiler, int b) {
    char c = 't';
    char str_buf[3];
    size_t length = 0;

    /* if b is false, c should be f */
    if(!b) {
        c = 'f';
    }

    length = sprintf(str_buf, " #%c", c);
    buffer_write(compiler->buf, (uint8_t *)str_buf, length);
}

/* Emit an empty list into the code stream */
void emit_empty(compiler_core_type *compiler) {
    char *empty = " ()";
    
    buffer_write(compiler->buf, (uint8_t *)empty, 3);
}

/* Emit a cons statement */
void emit_cons(compiler_core_type *compiler) {
    char *cons = " cons";
    
    buffer_write(compiler->buf, (uint8_t *)cons, 5);
}

/* Emit a fixnum string */
void emit_fixnum(compiler_core_type *compiler, char *num) {
    int length = strlen(num);

    buffer_write(compiler->buf, (uint8_t *)" ", 1);
    buffer_write(compiler->buf, (uint8_t *)num, length);
}

/* Interface into the compiler internals */
size_t compile_string(gc_type *gc, char *str, char **asm_ref) {
    yyscan_t scanner =0;
    size_t length = 0;
    compiler_core_type compiler;

    gc_register_root(gc, (void **)&compiler.buf);
    
    compiler.gc = gc;
    buffer_create(gc, &compiler.buf);
   
    // Actually parse the input stream.
    yylex_init(&scanner);
    yy_scan_string(str, scanner);

    parse_internal(&compiler, scanner);

    yylex_destroy(scanner);

    /* Convert the output buffer back to a string. */
    length = buffer_size(compiler.buf);
    gc_alloc(gc, 0, length, (void **)asm_ref);
    length = buffer_read(compiler.buf, (uint8_t *)*asm_ref, length);
    
    gc_unregister_root(gc, (void **)&compiler.buf);

    return length;
}
