#ifndef _BOOTSTRAP_INTERNAL
#define _BOOTSTRAP_INTERNAL

#include <gc.h>
#include <buffer.h>

typedef struct compiler_core compiler_core_type;

struct compiler_core {
    gc_type *gc;

    /* path to preamble and postamble code */
    char *preamble;
    char *postamble;

    uint64_t label_index;

    /* The current output buffer */
    buffer_type *buf;
};

void emit_bootstrap(compiler_core_type *compiler);

void emit_op(buffer_type *buf, char *str);
void emit_char(buffer_type *buf, char *str);
void emit_fixnum(buffer_type *buf, char *str);
void emit_string(buffer_type *buf, char *str);
void emit_symbol(buffer_type *buf, char *str);
void emit_boolean(buffer_type *buf, int b);

void emit_if(compiler_core_type *compiler, buffer_type *test_buffer,
  buffer_type *true_buffer, buffer_type *false_buffer);

void emit_lambda(compiler_core_type *compiler, buffer_type *output,
  buffer_type *formals, buffer_type *body);
  
void gen_label(compiler_core_type *compiler, buffer_type **buf);

/* Scheme parser */
int parse_internal(compiler_core_type *compiler, void *scanner);

/* Define some macros to make the parser code easier */
#define NEW_BUF(var) buffer_create(compiler->gc, &var)

#define EMIT(var, type, op) emit_##type(var, op)
#define EMIT_NEW(var, type, op) NEW_BUF(var); EMIT(var, type, op);


#endif
