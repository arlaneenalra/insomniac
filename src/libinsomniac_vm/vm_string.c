#include "vm_internal.h"

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
