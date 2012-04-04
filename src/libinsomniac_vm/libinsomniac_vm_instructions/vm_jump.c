#include "vm_instructions_internal.h"


/* jump if the top of stack is not false */
void op_jnf(vm_internal_type *vm) {
    object_type *obj =0 ;
    vm_int target = parse_int(vm);
    
    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_pop(vm);

    if(!(obj && obj->type == BOOL &&
         !obj->value.bool)) {
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
    /* push_env(vm); */
    /* env = vm->env; */
    /* pop_env(vm); */

    /* update the ip */
    env->ip +=target;
    
    closure->value.closure = env;

    vm_push(vm, closure);

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
        /* allocate a new closure */
        ret = vm_alloc(vm, CLOSURE);

        /* save our current environment */
        ret->value.closure = vm->env;
        vm_push(vm, ret);

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
