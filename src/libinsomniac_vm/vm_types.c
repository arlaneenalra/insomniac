#include "vm_internal.h"


/* setup the definition of a fix num type */
gc_type_def register_basic(gc_type *gc) {
    return gc_register_type(gc, sizeof(object_type));
}

/* setup the definition of a pair */
gc_type_def register_pair(gc_type *gc) {
    gc_type_def pair = 0;

    pair = gc_register_type(gc, sizeof(object_type));
    gc_register_pointer(gc, pair,
      offsetof(object_type, value) + offsetof(value_type, pair) +
      offsetof(pair_type, car));

    gc_register_pointer(gc, pair,
      offsetof(object_type, value) + offsetof(value_type, pair) +
      offsetof(pair_type, cdr));


    return pair;
}

/* register a string container type */
gc_type_def register_string(gc_type *gc) {
    gc_type_def str = 0;
    
    str = gc_register_type(gc, sizeof(object_type));
    gc_register_pointer(gc, str,
      offsetof(object_type, value) + offsetof(value_type, string) +
      offsetof(string_type, bytes));
    
    return str;
}

/* register a continuation container type */
gc_type_def register_closure(gc_type *gc) {
    gc_type_def closure = 0;
    
    closure = gc_register_type(gc, sizeof(object_type));
    gc_register_pointer(gc, closure,
      offsetof(object_type, value) + offsetof(value_type, closure));
    
    return closure;
}

/* register a library container type */
gc_type_def register_library(gc_type *gc) {
    gc_type_def library = 0;
    
    library = gc_register_type(gc, sizeof(object_type));
    
    return library;
}


/* register a vector type */
gc_type_def register_vector(gc_type *gc) {
    gc_type_def vector = 0;
    
    vector = gc_register_type(gc, sizeof(object_type));
    gc_register_pointer(gc, vector,
      offsetof(object_type, value) + offsetof(value_type, vector) +
      offsetof(vector_type, vector));

    return vector;
}

/* type used to store the execution state */
gc_type_def register_env(gc_type *gc) {
    gc_type_def env = 0;
    
    env = gc_register_type(gc, sizeof(env_type));

    gc_register_pointer(gc, env,
                        offsetof(env_type, code_ref));
    gc_register_pointer(gc, env,
                        offsetof(env_type, bindings));
    gc_register_pointer(gc, env,
                        offsetof(env_type, parent));

    return env;
}

/* setup gc type definitions */
void create_types(vm_internal_type *vm) {
    gc_type *gc=vm->gc;

    vm->types[FIXNUM] = register_basic(gc);
    vm->types[PAIR] = register_pair(gc);

    vm->types[BOOL] = register_basic(gc);
    vm->types[CHAR] = register_basic(gc);

    vm->types[STRING] = register_string(gc);
    vm->types[BYTE_VECTOR] = vm->types[RECORD] = vm->types[VECTOR] = register_vector(gc);

    vm->types[CLOSURE] = register_closure(gc);
    vm->types[LIBRARY] = register_library(gc);

    vm->types[EMPTY] = register_basic(gc);

    vm->env_type = register_env(gc);
}


/* create/registers the default vm internal type */
gc_type_def create_vm_type(gc_type *gc) {
    gc_type_def vm_type_def = 0;

    vm_type_def = gc_register_type(gc, sizeof(vm_internal_type));

    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, stack_root));
    gc_register_pointer(gc, vm_type_def,
                        offsetof(vm_internal_type, empty));
    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, vm_true));
    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, vm_false));

    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, reg1));
    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, reg2));
    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, reg3));

    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, symbol_table));
    gc_register_pointer(gc, vm_type_def,
                        offsetof(vm_internal_type, import_table));
    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, env));

    return vm_type_def;
}
