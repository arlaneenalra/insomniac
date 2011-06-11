#include "vm_internal.h"


/* setup the definition of a fix num type */
gc_type_def register_basic(gc_type *gc) {
    return gc_register_type(gc, sizeof(object_type));
}

/* setup the definition of a pair */
gc_type_def register_pair(gc_type *gc) {
    gc_type_def pair = 0;

    pair = gc_register_type(gc, sizeof(object_type));
    gc_register_pointer(gc, pair, offsetof(object_type, value.pair.car));
    gc_register_pointer(gc, pair, offsetof(object_type, value.pair.cdr));


    return pair;
}

/* register a string container type */
gc_type_def register_string(gc_type *gc) {
    gc_type_def str = 0;
    
    str = gc_register_type(gc, sizeof(object_type));
    gc_register_pointer(gc, str, offsetof(object_type, value.string.bytes));
    
    return str;
}

/* setup gc type definitions */
void create_types(vm_internal_type *vm) {
    gc_type *gc=vm->gc;

    vm->types[FIXNUM] = register_basic(gc);
    vm->types[PAIR] = register_pair(gc);

    vm->types[BOOL] = register_basic(gc);
    vm->types[CHAR] = register_basic(gc);

    vm->types[STRING] = register_string(gc);

    vm->types[EMPTY] = register_basic(gc);
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
                        offsetof(vm_internal_type, true));
    gc_register_pointer(gc, vm_type_def, 
                        offsetof(vm_internal_type, false));

    return vm_type_def;
}
