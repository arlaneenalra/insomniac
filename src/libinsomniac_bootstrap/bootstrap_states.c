#include "bootstrap_internal.h"
#include <assert.h>

#include <stdio.h>

void push_state(compiler_core_type *compiler, compiler_state_type state) {
  gc_type *gc = compiler->gc;
  state_stack *new_state = 0;

  gc_register_root(gc, (void **)&new_state);

  /* allocate a new state */
  gc_alloc_type(gc, 0, compiler->state_type, (void **)&new_state);

  /* Save the current buffer off */
  new_state->state = state;
  new_state->next = compiler->states;
  new_state->buf = compiler->buf;

  compiler->states = new_state;

  /* create a new buffer */
  buffer_create(gc, &compiler->buf);

  gc_unregister_root(gc, (void **)&new_state);
}

void pop_state(compiler_core_type *compiler) {
  state_stack *state = 0;

  if (compiler->states == 0) {
    fprintf(stderr, "Attempt to pop non-existent state!\n");
    assert(0);
  }

  // Loop through states until this chain of states is finished
  do {
    state = compiler->states;

    if (state->state == PUSH) {
      buffer_append(state->buf, compiler->buf, buffer_size(compiler->buf));
      compiler->buf = state->buf;
    } else {
      buffer_append(compiler->buf, state->buf, buffer_size(state->buf));
    }
    
    compiler->states = state->next;

  } while(compiler->states && state->state == CHAIN); 
  
}
