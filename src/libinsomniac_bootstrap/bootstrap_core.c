
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

/* Emit a character constanct */
void emit_char(compiler_core_type *compiler, char *c) {
    char *prefix = " #\\";

    buffer_write(compiler->buf, (uint8_t *)prefix, 3);
    buffer_write(compiler->buf, (uint8_t *)c, strlen(c));
}

/* Emit an empty list into the code stream */
void emit_empty(compiler_core_type *compiler) {
    char *empty = " ()";
    
    buffer_write(compiler->buf, (uint8_t *)empty, 3);
}

/* Emit a drop statement */
void emit_drop(compiler_core_type *compiler) {
  char *drop = " drop";
  
  buffer_write(compiler->buf, (uint8_t *)drop, 5);
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

/* Emit a string */
void emit_string(compiler_core_type *compiler, char *str) {
  int length = strlen(str);

  buffer_write(compiler->buf, (uint8_t *)" \"", 2);
  buffer_write(compiler->buf, (uint8_t *)str, length);
  buffer_write(compiler->buf, (uint8_t *)"\"", 1);
}

/* Emit a Symbol */
void emit_symbol(compiler_core_type *compiler, char *sym) {
  int length = strlen(sym);

  buffer_write(compiler->buf, (uint8_t *)" s\"", 3);
  buffer_write(compiler->buf, (uint8_t *)sym, length);
  buffer_write(compiler->buf, (uint8_t *)"\"", 1);
}

gc_type_def create_state_type(gc_type *gc) {
    gc_type_def type = 0;
    
    type = gc_register_type(gc, sizeof(state_stack));
    gc_register_pointer(gc, type, offsetof(state_stack, buf));
    gc_register_pointer(gc, type, offsetof(state_stack, next));

    return type;
}

/* Interface into the compiler internals */
// TODO: Make compiler code work like the other libraries
size_t compile_string(gc_type *gc, char *str, char **asm_ref) {
    static uint8_t init = 0;
    yyscan_t scanner =0;
    size_t length = 0;
    compiler_core_type compiler;

    gc_register_root(gc, (void **)&compiler.buf);
    gc_register_root(gc, (void **)&compiler.states);

    compiler.gc = gc;
    compiler.states = 0;
    compiler.preamble = "lib/preamble.asm";
    compiler.postamble = "lib/postamble.asm";


    if (!init) {
      compiler.state_type = create_state_type(compiler.gc);  
    }
    
    buffer_create(gc, &compiler.buf);

    /* Actually parse the input stream. */
    yylex_init(&scanner);
    yy_scan_string(str, scanner);

    parse_internal(&compiler, scanner);

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
