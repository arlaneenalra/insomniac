#include "vm_instructions_internal.h"

/* allocate a new byte vector */
void op_make_byte_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    
    vm->reg1 = obj = vm_pop(vm);

    /* make sure we have a number */
    assert(obj && obj->type == FIXNUM);

    length = obj->value.integer;

    vm->reg1 = obj = vm_make_byte_vector(vm, length);

    vm_push(vm, obj);
}

/* allocate a new vector */
void op_make_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    
    vm->reg1 = obj = vm_pop(vm);

    /* make sure we have a number */
    assert(obj && obj->type == FIXNUM);

    length = obj->value.integer;

    vm->reg1 = obj = vm_make_vector(vm, length);

    vm_push(vm, obj);
}

/* allocate a new record */
void op_make_record(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    
    vm->reg1 = obj = vm_pop(vm);

    /* make sure we have a number */
    assert(obj && obj->type == FIXNUM);

    length = obj->value.integer;

    vm->reg1 = obj = vm_make_record(vm, length);

    vm_push(vm, obj);
}

/* return the lenght of a vector */
void op_vector_length(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *length = 0;

    vm->reg1 = obj = vm_pop(vm);

    if (!obj || (obj->type != VECTOR && obj->type != BYTE_VECTOR)) {
      throw(vm, "Attempt to read vector length of non-vector!", 1, obj);
    }

    vm->reg2 = length = vm_alloc(vm, FIXNUM);
    length->value.integer = obj->value.vector.length;

    vm_push(vm, length);
}

/* set an element in a vector */
void op_index_set(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    vm->reg1 = vector = vm_pop(vm);
    vm->reg2 = obj = vm_pop(vm);
    vm->reg3 = obj_index = vm_pop(vm);

    assert(obj_index && obj_index->type == FIXNUM);
    
    index = obj_index->value.integer;

    assert(vector && (vector->type == VECTOR || vector->type == RECORD || vector->type == BYTE_VECTOR) &&
           vector->value.vector.length >= index);

    /* do the set */
    if (vector->type == VECTOR || vector->type == RECORD) {
        vector->value.vector.vector[index] = obj;
    } else {
        assert(obj && obj_index->type == FIXNUM);
        vector->value.byte_vector.vector[index] = obj->value.integer;
    }
}

/* read an element from a vector */
void op_index_ref(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    vm->reg1 = vector = vm_pop(vm);
    vm->reg2 = obj_index = vm_pop(vm);

    assert(obj_index && obj_index->type == FIXNUM);
    
    index = obj_index->value.integer;

    assert(vector && (vector->type == VECTOR || vector->type == RECORD || vector->type == BYTE_VECTOR) &&
           vector->value.vector.length >= index);

    /* do the read */
    if (vector->type == VECTOR || vector->type == RECORD) {
        vm->reg3 = obj = vector->value.vector.vector[index];
    } else {
        /* read an integer. */
        vm->reg3 = obj = vm_alloc(vm, FIXNUM);
        obj->value.integer = vector->value.byte_vector.vector[index];
    }

    vm_push(vm, obj);
}
