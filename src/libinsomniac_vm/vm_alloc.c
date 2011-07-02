#include "vm_internal.h"

/* Deal with cell alloction */
object_type *vm_alloc(vm_type *vm_void, cell_type type) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;

    /* Allocate an object using the GC type system */
    object_type *obj=gc_alloc_type(vm->gc, 0, vm->types[type]);
    
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

    obj->value.string.bytes = gc_alloc(vm->gc, 0, length+1);
    
    strncpy(obj->value.string.bytes, buf, length);

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

    /* allocate an array of pointers */
    /* obj->value.vector.vector = gc_alloc(vm->gc, 0, sizeof(object_type *) * length); */
    obj->value.vector.vector = 
        gc_alloc_pointer_array(vm->gc, 0, length);
    
    gc_unregister_root(vm->gc, (void**)&obj);

    return obj;
}
