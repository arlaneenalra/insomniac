
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

    length = snprintf(str_buf, 4, " #%c", c);
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

/* Emit an If */
void emit_if(compiler_core_type *compiler, buffer_type *test_buffer,
  buffer_type *true_buffer, buffer_type *false_buffer) {
  
  buffer_type *true_label = 0;
  buffer_type *done_label = 0;

  gc_register_root(compiler->gc, &true_label);
  gc_register_root(compiler->gc, &done_label);

  gen_label(compiler, &true_label);
  gen_label(compiler, &done_label);

  /* <test> jnf true */
  buffer_write(test_buffer, (uint8_t *)" jnf ", 5);
  buffer_append(test_buffer, true_label, -1);
  buffer_write(test_buffer, (uint8_t *) " ", 1);

  /* <false> jmp done */
  buffer_append(test_buffer, false_buffer, -1);

  buffer_write(test_buffer, (uint8_t *)" jmp ", 5);
  buffer_append(test_buffer, done_label, -1);
  buffer_write(test_buffer, (uint8_t *) " ", 1);

  /* true: */
  buffer_append(test_buffer, true_label, -1);
  buffer_write(test_buffer, (uint8_t *) ": ", 2);

  /* <true> */ 
  buffer_append(test_buffer, true_buffer, -1);
  buffer_write(test_buffer, (uint8_t *) " ", 1);

  /* done: */
  buffer_append(test_buffer, done_label, -1);
  buffer_write(test_buffer, (uint8_t *) ": ", 2);
  
  gc_unregister_root(compiler->gc, &done_label);
  gc_unregister_root(compiler->gc, &true_label);
}

/* Make a label */
void gen_label(compiler_core_type *compiler, buffer_type **buf) {
    char c[22];
    int written = 0;

    buffer_create(compiler->gc, buf);
    buffer_write(*buf, (uint8_t *)"_label_", 7);

    /* Add an incrementing suffix to the label */
    written = snprintf(c, 22, "%"PRIi64, compiler->label_index);
    buffer_write(*buf, (uint8_t *)c, written); 
    
    compiler->label_index++;
}

/* Interface into the compiler internals */
// TODO: Make compiler code work like the other libraries
size_t compile_string(gc_type *gc, char *str, char **asm_ref) {
    yyscan_t scanner =0;
    size_t length = 0;
    compiler_core_type compiler;

    gc_register_root(gc, (void **)&compiler.buf);

    compiler.gc = gc;
    compiler.label_index = 0;
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

