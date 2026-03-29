#include "vm_instructions_internal.h"

/* Jump if the top of stack is not false. */
void op_jnf(vm_internal_type *vm) {
#define obj vm->reg1
    vm_int target = parse_int(vm);

    BEGIN_OP;

    obj = vm_pop(vm);

    if (!(obj && obj->type == BOOL && !obj->value.boolean)) {
        vm->env->ip += target;
    }

    END_OP;
#undef obj
}

/* Straight jump. */
void op_jmp(vm_internal_type *vm) {
    vm_int target = parse_int(vm);

    BEGIN_OP;

    vm->env->ip += target;

    END_OP;
}

/* Create a procedure reference based on the current address
 and jump to target. */
void op_call(vm_internal_type *vm) {
#define clos vm->reg1
    vm_int target = parse_int(vm); /* get target address */

    BEGIN_OP;

    /* Allocate a new closure. */
    clos = vm_alloc(vm, CLOSURE);

    /* Save our current environment. */
    clos->value.closure = vm->env;
    vm_push(vm, clos);

    push_env(vm); /* Create a child of the current env. */

    /* Do the jump. */
    vm->env->ip += target;

    END_OP;
#undef clos
}

/* Rebind the parent of a proc to change the symbol look up
 environment. */
void op_adopt(vm_internal_type *vm) {
#define par vm->reg1
#define chld vm->reg2
#define adopted vm->reg3
    env_type *env = 0;

    BEGIN_OP;
    gc_register_root(vm->gc, (void **)&env);

    par = vm_pop(vm);
    chld = vm_pop(vm);

    if (!par || par->type != CLOSURE) {
        throw(vm, "Attempt to adopt with non-closure", 1, par);

    } else if (!chld || chld->type != CLOSURE) {
        throw(vm, "Attempt to adopt non-closure", 1, chld);

    } else {
        adopted = vm_alloc(vm, CLOSURE);

        /* copy the child into the new closure */
        clone_env(vm, (env_type **)&env, ((env_type *)chld->value.closure), true);

        adopted->value.closure = env;

        /* Setup adopted to use bindings/parent of par */
        env->parent = ((env_type *)par->value.closure)->parent;
        env->bindings = ((env_type *)par->value.closure)->bindings;

        vm_push(vm, adopted);
    }

    gc_unregister_root(vm->gc, (void **)&env);
    END_OP;
#undef par
#undef chld
#undef adopted
}

/* Create a procedure reference based on target and leave it
 on the stack. */
void op_proc(vm_internal_type *vm) {
#define clos vm->reg1
    vm_int target = parse_int(vm); /* Get target address. */
    env_type *env = 0;

    BEGIN_OP;
    gc_register_root(vm->gc, (void **)&env);

    /* Allocate a new closure. */
    clos = vm_alloc(vm, CLOSURE);

    /* Save our current environment. */
    clone_env(vm, &env, vm->env, false);

    /* Update the ip. */
    env->ip += target;

    clos->value.closure = env;

    vm_push(vm, clos);

    gc_unregister_root(vm->gc, (void **)&env);
    END_OP;
#undef clos
}

/* Jump indirect operation. */
void op_jin(vm_internal_type *vm) {
#define clos vm->reg1
    env_type *env = 0;

    BEGIN_OP;
    gc_register_root(vm->gc, (void **)&env);

    clos = vm_pop(vm);

    if (!clos || clos->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, clos);

    } else {

        /* Save the current environment. */
        env = vm->env;

        /* Clone the closures environment. */
        {
            env_type *new_env = 0;
            gc_register_root(vm->gc, (void **)&new_env);
            clone_env(vm, &new_env, clos->value.closure, false);
            vm->env = new_env;
            gc_unregister_root(vm->gc, (void **)&new_env);
        }

        /* Preserve the old bindings and parent so
           we have a jump equivalent. */
        /* WARNING: This does break/lose the current
           exception handler . . .*/
        vm->env->bindings = env->bindings;
        vm->env->parent = env->parent;
    }

    gc_unregister_root(vm->gc, (void **)&env);
    END_OP;
#undef clos
}

/* Return operation. */
void op_ret(vm_internal_type *vm) {
#define clos vm->reg1

    BEGIN_OP;

    clos = vm_pop(vm);

    if (!clos || clos->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, clos);

    } else {

        /* Clone the closures environment. */
        {
            env_type *new_env = 0;
            gc_register_root(vm->gc, (void **)&new_env);
            clone_env(vm, &new_env, clos->value.closure, false);
            vm->env = new_env;
            gc_unregister_root(vm->gc, (void **)&new_env);
        }
    }

    END_OP;
#undef clos
}

/* Call indirect operation. */
void op_call_in(vm_internal_type *vm) {
#define clos vm->reg1
#define ret vm->reg2

    BEGIN_OP;

    clos = vm_pop(vm);

    if (!clos || clos->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, clos);

    } else {
        /* Allocate a new closure. */
        ret = vm_alloc(vm, CLOSURE);

        /* Save our current environment. */
        ret->value.closure = vm->env;
        vm_push(vm, ret);

        /* Clone the closures environment. */
        {
            env_type *new_env = 0;
            gc_register_root(vm->gc, (void **)&new_env);
            clone_env(vm, &new_env, clos->value.closure, false);
            vm->env = new_env;
            gc_unregister_root(vm->gc, (void **)&new_env);
        }

        /* Create a child environment. */
        push_env(vm);
    }

    END_OP;
#undef clos
#undef ret
}

/* Tail call indirect operation. */
void op_tail_call_in(vm_internal_type *vm) {
#define clos vm->reg1

    BEGIN_OP;

    clos = vm_pop(vm);

    if (!clos || clos->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, clos);

    } else {

        /* Do a swap. */
        vm->reg2 = vm_pop(vm);
        vm->reg3 = vm_pop(vm);

        vm_push(vm, vm->reg2);
        vm_push(vm, vm->reg3);

        /* Clone the closures environment. */
        {
            env_type *new_env = 0;
            gc_register_root(vm->gc, (void **)&new_env);
            clone_env(vm, &new_env, clos->value.closure, false);
            vm->env = new_env;
            gc_unregister_root(vm->gc, (void **)&new_env);
        }

        /* Create a child environment. */
        push_env(vm);
    }

    END_OP;
#undef clos
}
/* Exception Handling code */

/* Set the exception handler for the current
   environment. */
void op_continue(vm_internal_type *vm) {
    vm_int target = parse_int(vm);

    BEGIN_OP;

    /* We need an absolute address for the
       exception handler as we don't know
       where it will be called from. */

    vm->env->handler = 1;
    vm->env->handler_addr = vm->env->ip + target;

    END_OP;
}

/* Set the exception handler for the current
   environment. */
void op_restore(vm_internal_type *vm) {
    BEGIN_OP;

    /* Restore the current exception handler. */
    vm->env->handler = 1;

    END_OP;
}

/* Throw an exception. */
void op_throw(vm_internal_type *vm) {
    BEGIN_OP;

    vm->reg1 = vm_pop(vm);
    vm->reg2 = vm_pop(vm);

    if (vm->reg2->type != STRING) {
        throw_fatal(vm, "Invalid exception message.", 2, vm->reg2, vm->reg1);
    }

    throw(vm, vm->reg2->value.string.bytes, 1, vm->reg1);

    END_OP;
}
