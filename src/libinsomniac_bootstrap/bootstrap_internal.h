#ifndef _BOOTSTRAP_INTERNAL
#define _BOOTSTRAP_INTERNAL

#include <gc.h>

typedef struct compiler_core compiler_core_type;

struct compiler_core {
    gc_type *gc;

};


void emit_bool(compiler_core_type *compiler, int b);


#endif
