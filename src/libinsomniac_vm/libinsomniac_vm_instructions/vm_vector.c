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

    assert(
        vector &&
        (vector->type == VECTOR || vector->type == RECORD ||
         vector->type == BYTE_VECTOR) &&
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

    assert(
        vector &&
        (vector->type == VECTOR || vector->type == RECORD ||
         vector->type == BYTE_VECTOR) &&
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

/* return a slice of a the passed in vector */
void op_slice(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *start = 0;
    object_type *end = 0;
    vm_int length = 0;

    vm->reg1 = vector = vm_pop(vm);
    vm->reg2 = end = vm_pop(vm);
    vm->reg3 = start = vm_pop(vm);

    assert(
        vector && (vector->type == VECTOR || vector->type == BYTE_VECTOR) &&
        vector->value.vector.length >= end->value.integer);

    length = end->value.integer - start->value.integer;

    assert(length >= 0);

    /* Vector and bytevector have the same internal structure, the only
       difference are the final pointer types. We can use this to avoid
       extraneous allocations and make accessing the members easier. */
    vm->reg2 = vm_alloc(vm, SLICE);
	vm->reg2->type = vector->type;

    vm->reg2->value.byte_vector.length = MIN(length, vector->value.byte_vector.length);
	vm->reg2->value.byte_vector.slice = true;

    /* We need to know the type to determine the size to offset by. */
    if (vector->type == VECTOR) {
        vm->reg2->value.vector.vector =
            vector->value.vector.vector + start->value.integer;
    } else {
        vm->reg2->value.byte_vector.vector =
            vector->value.byte_vector.vector + start->value.integer;
    }

    vm_push(vm, vm->reg2);
}

/* return a byte vector of a string. */
void op_string_slice(vm_internal_type *vm) {
    object_type *string = 0;
    object_type *slice = 0;
    
    vm->reg1 = string = vm_pop(vm);

    assert(string && string->type == STRING);

    vm->reg2 = slice = vm_alloc(vm, SLICE);
    slice->type = BYTE_VECTOR;

    slice->value.byte_vector.length = string->value.string.length;
    slice->value.byte_vector.slice = true;
    slice->value.byte_vector.vector = (uint8_t *)string->value.string.bytes;

    vm_push(vm, vm->reg2);
}

