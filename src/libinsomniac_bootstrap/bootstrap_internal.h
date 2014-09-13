#ifndef _BOOTSTRAP_INTERNAL
#define _BOOTSTRAP_INTERNAL

#include <gc.h>
#include <buffer.h>

typedef struct compiler_core compiler_core_type;

struct compiler_core {
    gc_type *gc;

    /* buffer used for generated code. */
    buffer_type *buf; 
};


void emit_bool(compiler_core_type *compiler, int b);
void emit_empty(compiler_core_type *compiler);
void emit_cons(compiler_core_type *compiler);
void emit_fixnum(compiler_core_type *compile, char *num);


/* Scheme parser */
int parse_internal(compiler_core_type *compiler, void *scanner);

#endif
