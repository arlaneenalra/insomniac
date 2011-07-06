#include "vm_internal.h"

/* create a new environment that is a child of 
   the current environement */
void push_env(vm_internal_type *vm) {
    env_type *new_env = 0;

    gc_register_root(vm->gc, (void **)&new_env);
    
    new_env = gc_alloc_type(vm->gc, 0, vm->env_type);
    
    /* create new hash table */
    new_env->bindings = hash_create_string(vm->gc);

    new_env->parent = vm->env;
    vm->env = new_env;

    gc_unregister_root(vm->gc, (void **)&new_env);
}

/* pop off the current environment */
void pop_env(vm_internal_type *vm) {
    if(vm->env) {
        vm->env = vm->env->parent;
    }
}