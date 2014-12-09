#include "vm_instructions_internal.h"

/* allocate a new vector */
void op_make_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    
    gc_protect(vm->gc);
    
    obj = vm_pop(vm);

    /* make sure we have a number */
    assert(obj && obj->type == FIXNUM);

    length = obj->value.integer;

    obj = vm_make_vector(vm, length);

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* return the lenght of a vector */
void op_vector_length(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *length = 0;

    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&length);
    
    obj = vm_pop(vm);

    if (!obj || obj->type != VECTOR) {
      throw(vm, "Attempt to read vector length of non-vector!", 1, obj);
    }

    length = vm_alloc(vm, FIXNUM);
    length->value.integer = obj->value.vector.length;

    vm_push(vm, length);

    gc_unregister_root(vm->gc, (void **)&length);
    gc_unregister_root(vm->gc, (void **)&obj);
}

/* set an element in a vector */
void op_vector_set(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    gc_protect(vm->gc);

    vector = vm_pop(vm);
    obj = vm_pop(vm);
    obj_index = vm_pop(vm);

    assert(obj_index && obj_index->type == FIXNUM);
    
    index = obj_index->value.integer;

    assert(vector && vector->type == VECTOR &&
           vector->value.vector.length >= index);

    /* do the set */
    vector->value.vector.vector[index] = obj;

    gc_unprotect(vm->gc);
}

/* read an element from a vector */
void op_vector_ref(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    gc_protect(vm->gc);

    vector = vm_pop(vm);
    obj_index = vm_pop(vm);

    assert(obj_index && obj_index->type == FIXNUM);
    
    index = obj_index->value.integer;

    assert(vector && vector->type == VECTOR &&
           vector->value.vector.length >= index);

    /* do the read */
    obj = vector->value.vector.vector[index];

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}
