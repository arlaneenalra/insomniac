
#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#include <stdio.h>

/* Emit a generic operations */
void emit_op(buffer_type *buf, char *str) {
    int length = strlen(str);

    buffer_write(buf, (uint8_t *)" ", 1);
    buffer_write(buf, (uint8_t *)str, length);
}

/* Emit a boolean into our code stream */
void emit_boolean(buffer_type *buf, int b) {
    char c = 't';
    char str_buf[4];
    size_t length = 0;

    /* if b is false, c should be f */
    if(!b) {
        c = 'f';
    }

    length = sprintf(str_buf, " #%c", c);
    buffer_write(buf, (uint8_t *)str_buf, length);
}

/* Emit a character constanct */
void emit_char(buffer_type *buf, char *c) {
    char *prefix = " #\\";

    buffer_write(buf, (uint8_t *)prefix, 3);
    buffer_write(buf, (uint8_t *)c, strlen(c));
}


/* Emit a fixnum string */
void emit_fixnum(buffer_type *buf, char *num) {
    int length = strlen(num);

    buffer_write(buf, (uint8_t *)" ", 1);
    buffer_write(buf, (uint8_t *)num, length);
}

/* Emit a string */
void emit_string(compiler_core_type *compiler, char *str) {
  int length = strlen(str);

  buffer_write(compiler->buf, (uint8_t *)" \"", 2);
  buffer_write(compiler->buf, (uint8_t *)str, length);
  buffer_write(compiler->buf, (uint8_t *)"\"", 1);
}

/* Emit a Symbol */
void emit_symbol(buffer_type *buf, char *sym) {
  int length = strlen(sym);

  buffer_write(buf, (uint8_t *)" s\"", 3);
  buffer_write(buf, (uint8_t *)sym, length);
  buffer_write(buf, (uint8_t *)"\"", 1);
}

/* Interface into the compiler internals */
// TODO: Make compiler code work like the other libraries
size_t compile_string(gc_type *gc, char *str, char **asm_ref) {
    yyscan_t scanner =0;
    size_t length = 0;
    compiler_core_type compiler;

    gc_register_root(gc, (void **)&compiler.buf);

    compiler.gc = gc;
    compiler.preamble = "lib/preamble.asm";
    compiler.postamble = "lib/postamble.asm";

    buffer_create(gc, &compiler.buf);

    /* Actually parse the input stream. */
    yylex_init(&scanner);
    yy_scan_string(str, scanner);

    /* TODO: Need a better way to handle GC than leaking */
    gc_protect(compiler.gc);
    
    parse_internal(&compiler, scanner);
    
    gc_protect(compiler.gc);

    yylex_destroy(scanner);

    /* Add appropriate bootstraping code */
    emit_bootstrap(&compiler);

    /* Convert the output buffer back to a string. */
    length = buffer_size(compiler.buf);
    gc_alloc(gc, 0, length, (void **)asm_ref);
    length = buffer_read(compiler.buf, (uint8_t *)*asm_ref, length);
    
    gc_unregister_root(gc, (void **)&compiler.buf);

    return length;
}
