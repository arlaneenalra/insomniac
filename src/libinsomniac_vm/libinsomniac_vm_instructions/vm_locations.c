#include "vm_instructions_internal.h"

/* bind a new location in the current environment */
void op_bind(vm_internal_type *vm) {
    object_type *key = 0;
    object_type *value = 0;

    gc_register_root(vm->gc, (void **)&key);
    gc_register_root(vm->gc, (void **)&value);

    key = vm_pop(vm);
    value = vm_pop(vm);

    /* make sure the key is a symbol */
    if (!key || key->type != SYMBOL) {
        throw(vm, "Attempt to bind with non-symbol", 2, key, value);
    } else {
        /* do the actual bind */
        hash_set(vm->env->bindings, key->value.string.bytes, value);
    }

    gc_unregister_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);
}

void op_read(vm_internal_type *vm) {
    object_type *key = 0;
    object_type *value = 0;
    env_type *env = 0;
    bool found = false;

    gc_register_root(vm->gc, (void **)&key);
    gc_register_root(vm->gc, (void **)&value);

    key = vm_pop(vm);

    /* make sure the key is a symbol */
    if (!key || key->type != SYMBOL) {
        throw(vm, "Attempt to read with non-symbol", 1, key);

        /* there has to be a better way to do this */
        gc_unregister_root(vm->gc, (void **)&value);
        gc_unregister_root(vm->gc, (void **)&key);
        return;
    }

    /* search all environments and parents for
       key */
    env = vm->env;
    while (env && !(found = hash_get(env->bindings, key->value.string.bytes, (void **)&value))) {
        env = env->parent;
    }

    /* we didn't find anything */
    if (!found) {
        throw(vm, "Attempt to read undefined symbol", 1, key);
    } else {
        vm_push(vm, value);
    }

    gc_unregister_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);
}

void op_set(vm_internal_type *vm) {
    object_type *key = 0;
    object_type *value = 0;
    int done = 0;
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&key);
    gc_register_root(vm->gc, (void **)&value);

    key = vm_pop(vm);
    value = vm_pop(vm);

    /* make sure the key is a symbol */
    if (!key || key->type != SYMBOL) {
        throw(vm, "Attempt to set with non-symbol", 2, key, value);

        gc_unregister_root(vm->gc, (void **)&value);
        gc_unregister_root(vm->gc, (void **)&key);
        return;
    }

    /* search all environments and parents for
       key */
    env = vm->env;
    while (env && !done) {
        /* did we find a binding for the symbol? */
        if (hash_get(env->bindings, key->value.string.bytes, 0)) {
            done = 1;

            /* save the value */
            hash_set(env->bindings, key->value.string.bytes, value);
        }
        env = env->parent;
    }

    /* don't allow writing of undefined symbols */
    if (!done) {
        throw(vm, "Attempt to set undefined symbol", 2, key, value);
    }

    gc_unregister_root(vm->gc, (void **)&key);
    gc_unregister_root(vm->gc, (void **)&value);
}

void op_set_exit(vm_internal_type *vm) {
    object_type *value = 0;

    gc_register_root(vm->gc, (void **)&value);

    value = vm_pop(vm);

    /* make sure the key is a symbol */
    if (!value || value->type != FIXNUM) {
        throw(vm, "Attempt to set non-number exit status", 1, value);

    } else {
        vm->exit_status = value->value.integer;
    }

    gc_unregister_root(vm->gc, (void **)&value);
}
