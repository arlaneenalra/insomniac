#include "vm_instructions_internal.h"

/* Jump if the top of stack is not false. */
void op_jnf(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int target = parse_int(vm);

    vm->reg1 = obj = vm_pop(vm);

    if (!(obj && obj->type == BOOL && !obj->value.boolean)) {
        vm->env->ip += target;
    }
}

/* Straight jump. */
void op_jmp(vm_internal_type *vm) {
    vm_int target = parse_int(vm);

    vm->env->ip += target;
}

/* Create a procedure reference based on the current address
 and jump to target. */
void op_call(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* get target address */

    /* Allocate a new closure. */
    vm->reg1 = closure = vm_alloc(vm, CLOSURE);

    /* Save our current environment. */
    closure->value.closure = vm->env;
    vm_push(vm, closure);

    push_env(vm); /* Create a child of the current env. */

    /* Do the jump. */
    vm->env->ip += target;
}

/* Rebind the parent of a proc to change the symbol look up
 environment. */
void op_adopt(vm_internal_type *vm) {
    object_type *child = 0;
    object_type *parent = 0;
    object_type *adopted = 0;
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&env);

    vm->reg1 = parent = vm_pop(vm);
    vm->reg2 = child = vm_pop(vm);

    if (!parent || parent->type != CLOSURE) {
        throw(vm, "Attempt to adopt with non-closure", 1, parent);

    } else if (!child || child->type != CLOSURE) {
        throw(vm, "Attempt to adopt non-closure", 1, child);

    } else {
        vm->reg3 = adopted = vm_alloc(vm, CLOSURE);

        /* copy the child into the new closure */
        clone_env(vm, (env_type **)&env, ((env_type *)child->value.closure), true);

        adopted->value.closure = env;

        /* Setup adopted to use bindings/parent of parent */
        env->parent = ((env_type *)parent->value.closure)->parent;
        env->bindings = ((env_type *)parent->value.closure)->bindings;

        vm_push(vm, adopted);
    }

    gc_unregister_root(vm->gc, (void **)&env);
}

/* Create a procedure reference based on target and leave it
 on the stack. */
void op_proc(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* Get target address. */
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&env);

    /* Allocate a new closure. */
    vm->reg1 = closure = vm_alloc(vm, CLOSURE);

    /* Save our current environment. */
    clone_env(vm, &env, vm->env, false);

    /* Update the ip. */
    env->ip += target;

    closure->value.closure = env;

    vm_push(vm, closure);

    gc_unregister_root(vm->gc, (void **)&env);
}

/* Jump indirect operation. */
void op_jin(vm_internal_type *vm) {
    object_type *closure = 0;
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&env);

    vm->reg1 = closure = vm_pop(vm);

    if (!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {

        /* Save the current environment. */
        env = vm->env;

        /* Clone the closures environment. */
        clone_env(vm, &(vm->env), closure->value.closure, false);

        /* Preserve the old bindings and parent so
           we have a jump equivalent. */
        /* WARNING: This does break/lose the current
           exception handler . . .*/
        vm->env->bindings = env->bindings;
        vm->env->parent = env->parent;
    }

    gc_unregister_root(vm->gc, (void **)&env);
}

/* Return operation. */
void op_ret(vm_internal_type *vm) {
    object_type *closure = 0;

    vm->reg1 = closure = vm_pop(vm);

    if (!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {

        /* Clone the closures environment. */
        clone_env(vm, &(vm->env), closure->value.closure, false);
    }
}

/* Call indirect operation. */
void op_call_in(vm_internal_type *vm) {
    object_type *closure = 0;
    object_type *ret = 0;

    vm->reg1 = closure = vm_pop(vm);

    if (!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        /* Allocate a new closure. */
        vm->reg2 = ret = vm_alloc(vm, CLOSURE);

        /* Save our current environment. */
        ret->value.closure = vm->env;
        vm_push(vm, ret);

        /* Clone the closures environment. */
        clone_env(vm, &(vm->env), closure->value.closure, false);

        /* Create a child environment. */
        push_env(vm);
    }
}

/* Tail call indirect operation. */
void op_tail_call_in(vm_internal_type *vm) {
    object_type *closure = 0;

    vm->reg1 = closure = vm_pop(vm);

    if (!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {

        /* Do a swap. */
        vm->reg2 = vm_pop(vm);
        vm->reg3 = vm_pop(vm);

        vm_push(vm, vm->reg2);
        vm_push(vm, vm->reg3);

        /* Clone the closures environment. */
        clone_env(vm, &(vm->env), closure->value.closure, false);

        /* Create a child environment. */
        push_env(vm);
    }
}
/* Exception Handling code */

/* Set the exception handler for the current
   environment. */
void op_continue(vm_internal_type *vm) {
    vm_int target = parse_int(vm);

    /* We need an absolute address for the
       exception handler as we don't know
       where it will be called from. */

    vm->env->handler = 1;
    vm->env->handler_addr = vm->env->ip + target;
}

/* Set the exception handler for the current
   environment. */
void op_restore(vm_internal_type *vm) {
    /* Restore the current exception handler. */
    vm->env->handler = 1;
}

/* Throw an exception. */
void op_throw(vm_internal_type *vm) {
    vm->reg1 = vm_pop(vm);
    vm->reg2 = vm_pop(vm);
    
    if (vm->reg2->type != STRING) {
        throw_fatal(vm, "Invalid exception message.", 2, vm->reg2, vm->reg1);
    }

    throw(vm, vm->reg2->value.string.bytes, 1, vm->reg1);
}

