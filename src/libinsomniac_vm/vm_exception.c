#include "vm_internal.h"

#include <assert.h>

/* Throw an exception. */
void handle_exception(vm_internal_type * vm, char *msg, bool fatal, int num, ...) {
    va_list ap;
    object_type *exception = 0;
    object_type *cons_temp = 0;
    object_type *obj = 0;

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
        while (vm->env && !vm->env->handler) {
            vm->env = vm->env->parent;
        }

        /* Did we find a handler? */
        if (vm->env) {
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

    printf("Exception:\n");
    output_object(stdout, exception);

    printf("\nCurrent Stack:\n");
    output_object(stdout, vm->stack_root);
    printf("\n");

    assert(0);
}

