#include "vm_instructions_internal.h"


/* jump if the top of stack is not false */
void op_jnf(vm_internal_type *vm) {
    object_type *obj =0 ;
    vm_int target = parse_int(vm);
    
    vm->reg1 = obj = vm_pop(vm);

    if(!(obj && obj->type == BOOL &&
         !obj->value.boolean)) {
        vm->env->ip += target;
    }
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

    /* allocate a new closure */
    vm->reg1 = closure = vm_alloc(vm, CLOSURE);

    /* save our current environment */
    closure->value.closure = vm->env;
    vm_push(vm, closure);

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
  
  gc_register_root(vm->gc, (void **)&env);

  vm->reg1 = parent = vm_pop(vm);
  vm->reg2 = child = vm_pop(vm);

  if(!parent || parent->type != CLOSURE) {
      throw(vm, "Attempt to adopt with non-closure", 1, parent);

  } else if(!child || child->type != CLOSURE) {
      throw(vm, "Attempt to adopt non-closure", 1, child);

  } else {
    vm->reg3 = adopted = vm_alloc(vm, CLOSURE);
    
    /* copy the child into the new closure */
    clone_env(vm, (env_type **)&env, 
      ((env_type *)child->value.closure), true);
    
    adopted->value.closure = env;

    /* Setup adopted to use bindings/parent of parent */
    env->parent = ((env_type *)parent->value.closure)->parent;
    env->bindings = ((env_type *)parent->value.closure)->bindings;
    
    vm_push(vm, adopted);
  }

  gc_unregister_root(vm->gc, (void **)&env);
}

/* create a procedure reference based on target and leave it 
 on the stack*/
void op_proc(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* get target address */
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&env);

    /* allocate a new closure */
    vm->reg1 = closure = vm_alloc(vm, CLOSURE);

    /* save our current environment */
    clone_env(vm, (env_type **)&env, vm->env, false);

    /* update the ip */
    env->ip +=target;
    
    closure->value.closure = env;

    vm_push(vm, closure);

    gc_unregister_root(vm->gc, (void **)&env);
}

/* jump indirect operation */
void op_jin(vm_internal_type *vm) {
    object_type *closure = 0;
    env_type *env = 0;
    
    gc_register_root(vm->gc, (void **)&env);
    
    vm->reg1 = closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        
        /* save the current environment */
        env = vm->env;

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure, false);

        /* preserve the old bindings and parent so 
           we have a jump equivalent. */
        /* WARNING: This does break/lose the current 
           exception handler . . .*/
        vm->env->bindings = env->bindings;
        vm->env->parent = env->parent;
    }

    gc_unregister_root(vm->gc, (void **)&env);
}

/* return operation */
void op_ret(vm_internal_type *vm) {
    object_type *closure = 0;
    
    vm->reg1 = closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure, false);
    }
}


/* call indirect operation */
void op_call_in(vm_internal_type *vm) {
    object_type *closure = 0;
    object_type *ret = 0;
    
    vm->reg1 = closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        /* allocate a new closure */
        vm->reg2 = ret = vm_alloc(vm, CLOSURE);

        /* save our current environment */
        ret->value.closure = vm->env;
        vm_push(vm, ret);

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure, false);

        /* create a child environment */
        push_env(vm);
    }
}

/* tail call indirect operation */
void op_tail_call_in(vm_internal_type *vm) {
    object_type *closure = 0;
    
    vm->reg1 = closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        op_swap(vm);

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure, false);

        /* create a child environment */
        push_env(vm);
    }
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
