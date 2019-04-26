#include "vm_internal.h"

/* Deal with cell alloction */
object_type *vm_alloc(vm_type *vm_void, cell_type type) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj=0;

    if (type == EMPTY && vm->empty) {
      return vm->empty;
    }

    /* Allocate an object using the GC type system */
    gc_alloc_type(vm->gc, 0, vm->types[type], (void **)&obj);
    obj->type=type;

    return obj; 
}

/* Create a string object from the given string */
object_type *vm_make_string(vm_type *vm_void, char *buf, vm_int length) {
    vm_internal_type *vm=(vm_internal_type *)vm_void;
    object_type *obj = 0;

    /* construct a new string object using the 
       length and passed in character buffer */
    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_alloc(vm, STRING);
    obj->value.string.length = length;

    gc_alloc(vm->gc, 0, length+1, (void**)&(obj->value.string.bytes));
    
    strncpy(obj->value.string.bytes, buf, length);

    gc_unregister_root(vm->gc, (void**)&obj);

    return obj;
}

/* Allocate an empty byte vector of the given size */
object_type *vm_make_byte_vector(vm_type *vm_void, vm_int length) {
    vm_internal_type *vm=(vm_internal_type *)vm_void;
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_alloc(vm, BYTE_VECTOR);
    obj->value.byte_vector.length = length;
    obj->value.byte_vector.slice = false;

    /* allocate an array of pointers */
    gc_alloc(vm->gc, 0, length, (void **)&(obj->value.byte_vector.vector));
    
    gc_unregister_root(vm->gc, (void**)&obj);

    return obj;
}

/* Allocate an empty vector of the given size */
object_type *vm_make_vector(vm_type *vm_void, vm_int length) {
    vm_internal_type *vm=(vm_internal_type *)vm_void;
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_alloc(vm, VECTOR);
    obj->value.vector.length = length;
    obj->value.byte_vector.slice = false;

    /* allocate an array of pointers */
    gc_alloc_pointer_array(vm->gc, 0, length, (void **)&(obj->value.vector.vector));
    
    gc_unregister_root(vm->gc, (void**)&obj);

    return obj;
}

/* Allocate an empyt record of the given size */
// TODO:  The record definition will likely need to change at some point. 
object_type *vm_make_record(vm_type *vm_void, vm_int length) {
    /* first element of a vector is always special */
    object_type *obj = vm_make_vector(vm_void, length + 1);
    obj->type = RECORD;

    return obj;
}
