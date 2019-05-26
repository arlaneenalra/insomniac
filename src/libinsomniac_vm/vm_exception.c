#include "vm_internal.h"

#include <assert.h>

void find_source_location(FILE* fout, env_type *env) {
    uint64_t i = 0;

    if (env->debug_count == 0) { 
        fprintf(fout, "No debugging info found.\n");
        return;
    }

    if (env->ip < env->debug[0].start_addr) {
        fprintf(fout, "[Preamble code.]\n");
        return;
    }

    /* Find where the exception occured. */ 
    for (i = 0; i < env->debug_count && env->debug[i].start_addr < env->ip; i ++);

    /* If i is less than the cound, we found a debug record. */ 
    if (i < env->debug_count) {
        fprintf(
            fout, 
            "At File: %s, Line: %" PRIi64 " Col: %" PRIi64 " Addr: %" PRIi64 " Real Addr: %zu\n",
            env->debug[i].file, env->debug[i].line, env->debug[i].column,
            env->debug[i].start_addr, env->ip);
    } else {
        fprintf(fout, "Uknown location!\n");
    }
}

/* Throw an exception. */
void handle_exception(vm_internal_type * vm, char *msg, bool fatal, int num, ...) {
    va_list ap;
    object_type *exception = 0;
    object_type *cons_temp = 0;
    object_type *obj = 0;
    env_type *env = 0;

    /* make the exception */
    gc_register_root(vm->gc, (void **)&exception);
    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&cons_temp);

    exception = vm->empty;

    /* save off any given objects */
    va_start(ap, num);

    for (int i = 0; i < num; i++) {
        obj = va_arg(ap, object_type *);
        cons(vm, obj, exception, &cons_temp);
        exception = cons_temp;
    }

    va_end(ap);

    /* Save the current point in the execution. */
    obj = vm_alloc(vm, CLOSURE);
    clone_env(vm, (env_type **)&(obj->value.closure), vm->env, false);

    cons(vm, obj, exception, &cons_temp);
    exception = cons_temp;

    /* Make a string object for the message. */
    obj = vm_make_string(vm, msg, strlen(msg));

    /* Put everything in a pair. */
    cons(vm, obj, exception, &cons_temp);
    exception = cons_temp;

    /* Put the exception itself on the stack. */
    vm_push(vm, exception);

    gc_unregister_root(vm->gc, (void **)&cons_temp);
    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&exception);


    if (!fatal) {
        /* Go hunting for the exception handler routine. */
        env = vm->env;
        while (env && !env->handler) {
            env = env->parent;
        }

        /* Did we find a handler? */
        if (env) {
            /* Set the env to the one we found. */
            vm->env = env;

            clone_env(vm, (env_type **)&(vm->env), vm->env, false);
            /* Disable exception handler while handling exceptions. */
            vm->env->handler = 0;

            /* We can assume that if vm is a valid pointer,
               handler is a valid pointer. */
            vm->env->ip = vm->env->handler_addr;
            return;
        }
    }

    /* We did not find a handler ! */
    vm_pop(vm);

    printf("\n\nUnhandled Exception: '%s'\n", msg);

    find_source_location(stdout, vm->env);

    printf("Exception:\n");
    output_object(stdout, exception);

    printf("\nCurrent Stack:\n");
    output_object(stdout, vm->stack_root);
    printf("\n");

    assert(0);
}

