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

/* setup gc type definitions */
void create_types(vm_internal_type *vm) {
    gc_type *gc=vm->gc;

    vm->types[FIXNUM] = register_basic(gc);
    vm->types[PAIR] = register_pair(gc);
    vm->types[EMPTY] = register_basic(gc);
}
