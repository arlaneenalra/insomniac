#include "vm_internal.h"

/* create a new environment that is a child of 
   the current environement */
void push_env(vm_internal_type *vm) {
    env_type *new_env = 0;

    gc_register_root(vm->gc, (void **)&new_env);
    
    gc_alloc_type(vm->gc, 0, vm->env_type, (void **)&new_env);
    
    /* create new hash table */
    new_env->bindings = hash_create_string(vm->gc);

    new_env->parent = vm->env;
    vm->env = new_env;

    /* if we have a parent, save off the parents
       ip and code_ref */
    if(vm->env->parent) {
        vm->env->code_ref = vm->env->parent->code_ref;
        vm->env->ip = vm->env->parent->ip;
        vm->env->length = vm->env->parent->length;
    }

    gc_unregister_root(vm->gc, (void **)&new_env);
}

/* create a copy of the environment in a new environment */
void clone_env(vm_internal_type *vm, env_type **target,
               env_type *env) {    

    gc_alloc_type(vm->gc, 0, vm->env_type, (void **)target);

    /* copy env to vm->env */
    memcpy(*target, env, sizeof(env_type));
}

/* pop off the current environment */
void pop_env(vm_internal_type *vm) {
    if(vm->env) {
        vm->env = vm->env->parent;
    }
}
