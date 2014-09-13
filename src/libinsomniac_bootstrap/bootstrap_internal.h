#ifndef _BOOTSTRAP_INTERNAL
#define _BOOTSTRAP_INTERNAL

#include <gc.h>
#include <buffer.h>


typedef enum compiler_state {
  PUSH, /* Pushed states are new constructs */  
  CHAIN /* Chained states are part of an existing construct */
} compiler_state_type;

typedef struct state state_stack;

struct state {
  compiler_state_type state; 
  buffer_type *buf;
  state_stack *next;  
};

typedef struct compiler_core compiler_core_type;

struct compiler_core {
    gc_type *gc;

    gc_type_def state_type;

    /* A state of compiler states */
    state_stack *states;

    /* The current output buffer */
    buffer_type *buf;
};


void emit_bool(compiler_core_type *compiler, int b);
void emit_empty(compiler_core_type *compiler);
void emit_drop(compiler_core_type *compiler);
void emit_cons(compiler_core_type *compiler);
void emit_fixnum(compiler_core_type *compile, char *num);
void emit_symbol(compiler_core_type *compile, char *sym);
void emit_string(compiler_core_type *compile, char *str);


/* Scheme parser */
int parse_internal(compiler_core_type *compiler, void *scanner);

/* Compiler states */
void push_state(compiler_core_type *compiler, compiler_state_type state);
void pop_state(compiler_core_type *compiler);

#endif
