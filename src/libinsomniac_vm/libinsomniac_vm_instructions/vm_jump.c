#include "vm_instructions_internal.h"


/* a crude/quick test for tail calls, if primarily looks 
   for a "swap ret" pair following a call */
bool test_tail(vm_internal_type *vm) {
  return vm_peek(vm, 0) == (uint8_t)OP_SWAP
      && vm_peek(vm, 1) == (uint8_t)OP_RET;
}

/* jump if the top of stack is not false */
void op_jnf(vm_internal_type *vm) {
    object_type *obj =0 ;
    vm_int target = parse_int(vm);
    
    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_pop(vm);

    if(!(obj && obj->type == BOOL &&
         !obj->value.boolean)) {
        vm->env->ip += target;
    }

    gc_unregister_root(vm->gc, (void**)&obj);
}

/* straight jump */
void op_jmp(vm_internal_type *vm) {
    vm_int target = parse_int(vm);
    
    vm->env->ip += target;
}


/* create a procedure reference based on the current address
 and jump to target */
void op_call(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* get target address */

    gc_register_root(vm->gc, (void **)&closure);

    /* allocate a new closure */
    closure = vm_alloc(vm, CLOSURE);

    /* save our current environment */
    closure->value.closure = vm->env;
    vm_push(vm, closure);

    gc_unregister_root(vm->gc, (void **)&closure);

    push_env(vm); /* create a child of the current env */

    /* Do the jump */
    vm->env->ip += target;
}

/* Rebind the parent of a proc to change the symbol look up
 environment */
void op_adopt(vm_internal_type *vm) {
  object_type *child = 0;
  object_type *parent = 0;
  object_type *adopted = 0;
  env_type *env = 0;
  
  gc_register_root(vm->gc, (void **)&child);
  gc_register_root(vm->gc, (void **)&parent);
  gc_register_root(vm->gc, (void **)&adopted);
  gc_register_root(vm->gc, (void **)&env);

  parent = vm_pop(vm);
  child = vm_pop(vm);

  if(!parent || parent->type != CLOSURE) {
      throw(vm, "Attempt to adopt with non-closure", 1, parent);

  } else if(!child || child->type != CLOSURE) {
      throw(vm, "Attempt to adopt non-closure", 1, child);

  } else {
    adopted = vm_alloc(vm, CLOSURE);
    
    /* copy the child into the new closure */
    clone_env(vm, (env_type **)&env, 
      ((env_type *)child->value.closure));
    
    adopted->value.closure = env;

    /* Setup adopted to use bindings/parent of parent */
    env->parent = ((env_type *)parent->value.closure)->parent;
    env->bindings = ((env_type *)parent->value.closure)->bindings;
    
    vm_push(vm, adopted);
  }

  gc_unregister_root(vm->gc, (void **)&env);
  gc_unregister_root(vm->gc, (void **)&adopted);
  gc_unregister_root(vm->gc, (void **)&child);
  gc_unregister_root(vm->gc, (void **)&parent);
}

/* create a procedure reference based on target and leave it 
 on the stack*/
void op_proc(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* get target address */
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&closure);
    gc_register_root(vm->gc, (void **)&env);

    /* allocate a new closure */
    closure = vm_alloc(vm, CLOSURE);

    /* save our current environment */
    clone_env(vm, (env_type **)&env, vm->env);

    /* update the ip */
    env->ip +=target;
    
    closure->value.closure = env;

    vm_push(vm, closure);

    gc_unregister_root(vm->gc, (void **)&env);
    gc_unregister_root(vm->gc, (void **)&closure);

}

/* jump indirect operation */
void op_jin(vm_internal_type *vm) {
    object_type *closure = 0;
    env_type *env = 0;
    
    gc_register_root(vm->gc, (void **)&closure);
    gc_register_root(vm->gc, (void **)&env);
    
    closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        
        /* save the current environment */
        env = vm->env;

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure);

        /* preserve the old bindings and parent so 
           we have a jump equivalent. */
        /* WARNING: This does break lose the current 
           exception handler . . .*/
        vm->env->bindings = env->bindings;
        vm->env->parent = env->parent;
    }

    gc_unregister_root(vm->gc, (void **)&env);
    gc_unregister_root(vm->gc, (void **)&closure);
}

/* return operation */
void op_ret(vm_internal_type *vm) {
    object_type *closure = 0;
    
    gc_register_root(vm->gc, (void **)&closure);
    
    closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure);
    }

    gc_unregister_root(vm->gc, (void **)&closure);
}


/* call indirect operation */
void op_call_in(vm_internal_type *vm) {
    object_type *closure = 0;
    object_type *ret = 0;
    
    gc_register_root(vm->gc, (void **)&closure);
    gc_register_root(vm->gc, (void **)&ret);
    
    closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        if (!test_tail(vm)) {
          /* allocate a new closure */
          ret = vm_alloc(vm, CLOSURE);

          /* save our current environment */
          ret->value.closure = vm->env;
          vm_push(vm, ret);
        } else {
          op_swap(vm);
        }

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure);
        /* create a child environment */
        push_env(vm);
    }

    gc_unregister_root(vm->gc, (void **)&ret);
    gc_unregister_root(vm->gc, (void **)&closure);
}


/* Exception Handling code */

/* set the exception handler for the current 
   environment */
void op_continue(vm_internal_type *vm) {
    vm_int target = parse_int(vm);

    /* we need an absolute address for the 
       exception handler as we don't know 
       where it will be called from */

    vm->env->handler = 1;
    vm->env->handler_addr = vm->env->ip + target;
}

/* set the exception handler for the current 
   environment */
void op_restore(vm_internal_type *vm) {
    /* restore the current exception handler */
    vm->env->handler = 1;
}
