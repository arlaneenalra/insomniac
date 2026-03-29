#include "vm_internal.h"

/* Deal with cell alloction */
object_type *vm_alloc(vm_type *vm_void, cell_type type) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;

    if (type == EMPTY && vm->empty) {
        return vm->empty;
    }

    gc_register_root(vm->gc, (void **)&vm);

    /* Allocate an object using the GC type system */
    gc_alloc_type(vm->gc, vm->types[type], (void **)&obj);
    obj->type = type;

    gc_unregister_root(vm->gc, (void **)&vm);

    return obj;
}

/* Create a string object from the given string */
object_type *vm_make_string(vm_type *vm_void, char *buf, vm_int length) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;
    char *bytes = 0;

    /* Allocate into local roots first, then assign to object fields.
       This avoids stale pointer writes if GC relocates obj during
       the second allocation. */
    gc_register_root(vm->gc, (void **)&vm);
    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&bytes);

    obj = vm_alloc(vm, STRING);
    obj->value.string.length = length;

    gc_alloc(vm->gc, length + 1, (void **)&bytes);
    obj->value.string.bytes = bytes;

    strncpy(obj->value.string.bytes, buf, length);

    gc_unregister_root(vm->gc, (void **)&bytes);
    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&vm);

    return obj;
}

/* Allocate an empty byte vector of the given size */
object_type *vm_make_byte_vector(vm_type *vm_void, vm_int length) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;
    uint8_t *vector = 0;

    gc_register_root(vm->gc, (void **)&vm);
    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&vector);

    obj = vm_alloc(vm, BYTE_VECTOR);
    obj->value.byte_vector.length = length;

    gc_alloc(vm->gc, length, (void **)&vector);
    obj->value.byte_vector.vector = vector;

    gc_unregister_root(vm->gc, (void **)&vector);
    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&vm);

    return obj;
}

/* Allocate an empty vector of the given size */
object_type *vm_make_vector(vm_type *vm_void, vm_int length) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;
    object_type **vector = 0;

    gc_register_root(vm->gc, (void **)&vm);
    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&vector);

    obj = vm_alloc(vm, VECTOR);
    obj->value.vector.length = length;

    gc_alloc_pointer_array(vm->gc, length, (void **)&vector);
    obj->value.vector.vector = vector;

    gc_unregister_root(vm->gc, (void **)&vector);
    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&vm);

    return obj;
}

/* Allocate an empty record of the given size */
/* TODO:  The record definition will likely need to change at some point. */
object_type *vm_make_record(vm_type *vm_void, vm_int length) {
    /* first element of a vector is always special */
    object_type *obj = vm_make_vector(vm_void, length + 1);
    obj->type = RECORD;

    return obj;
}
