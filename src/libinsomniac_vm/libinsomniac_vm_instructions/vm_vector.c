#include "vm_instructions_internal.h"

/* Allocate a new byte vector. */
void op_make_byte_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;

    vm->reg1 = obj = vm_pop(vm);

    /* Make sure we have a number. */
    if (obj->type != FIXNUM) {
        throw(vm, "Make byte vector requires a number argument.", 1, obj);
        return;
    }

    length = obj->value.integer;

    vm->reg1 = obj = vm_make_byte_vector(vm, length);

    vm_push(vm, obj);
}

/* Allocate a new vector. */
void op_make_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;

    vm->reg1 = obj = vm_pop(vm);

    /* Make sure we have a number. */
    if (obj->type != FIXNUM) {
        throw(vm, "Make vector requires a number argument.", 1, obj);
        return;
    }

    length = obj->value.integer;

    vm->reg1 = obj = vm_make_vector(vm, length);

    vm_push(vm, obj);
}

/* Allocate a new record. */
void op_make_record(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;

    vm->reg1 = obj = vm_pop(vm);

    /* Make sure we have a number. */
    if (obj->type != FIXNUM) {
        throw(vm, "Make record requires a number argument.", 1, obj);
        return;
    }

    length = obj->value.integer;

    vm->reg1 = obj = vm_make_record(vm, length);

    vm_push(vm, obj);
}

/* Return the length of a vector. */
void op_vector_length(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *length = 0;

    vm->reg1 = obj = vm_pop(vm);

    if (obj->type != VECTOR && obj->type != BYTE_VECTOR) {
        throw(vm, "Attempt to read vector length of non-vector!", 1, obj);
        return;
    }

    vm->reg2 = length = vm_alloc(vm, FIXNUM);
    length->value.integer = obj->value.vector.length;

    vm_push(vm, length);
}

/* Set an element in a vector. */
void op_index_set(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    vm->reg1 = vector = vm_pop(vm);
    vm->reg2 = obj = vm_pop(vm);
    vm->reg3 = obj_index = vm_pop(vm);

    if (obj_index->type != FIXNUM) {
        throw(vm, "The index must be a number.", 1, obj_index);
        return;
    }

    index = obj_index->value.integer;

    /* Make sure we have a vector or equivalent. */
    if (!((vector->type == VECTOR ||
        vector->type == RECORD ||
        vector->type == BYTE_VECTOR
        ) && vector->value.vector.length >= index)) {
        
        throw(vm, "Set by index requires a vector.", 1, vector);
        return;
    } 

    /* Do the set. */
    if (vector->type == VECTOR || vector->type == RECORD) {
        vector->value.vector.vector[index] = obj;
    } else {
        if (obj->type != FIXNUM) {
            throw(vm, "Byte vectors may only contain numbers.", 1, obj);
            return;
        }
        vector->value.byte_vector.vector[index] = obj->value.integer;
    }
}

/* Read an element from a vector. */
void op_index_ref(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    vm->reg1 = vector = vm_pop(vm);
    vm->reg2 = obj_index = vm_pop(vm);

    if (obj_index->type != FIXNUM) {
        throw(vm, "The index must be a number.", 1, obj_index);
        return;
    }

    index = obj_index->value.integer;
    

    /* Make sure we have a vector or equivalent. */
    if (!((vector->type == VECTOR ||
        vector->type == RECORD ||
        vector->type == BYTE_VECTOR
        ) && vector->value.vector.length >= index)) {
        
        throw(vm, "Read by index requires a vector.", 1, vector);
        return;
    } 

    /* Do the read. */
    if (vector->type == VECTOR || vector->type == RECORD) {
        vm->reg3 = obj = vector->value.vector.vector[index];
    } else {
        /* Read an integer. */
        vm->reg3 = obj = vm_alloc(vm, FIXNUM);
        obj->value.integer = vector->value.byte_vector.vector[index];
    }

    vm_push(vm, obj);
}

/* return a byte vector of a string. */
void op_string_byte_vector(vm_internal_type *vm) {
    object_type *string = 0;
    object_type *slice = 0;
    
    vm->reg1 = string = vm_pop(vm);

    if (string->type != STRING) {
        throw(vm, "str->u8 requires a string argument.", 1, string);
        return;
    }

    vm->reg2 = slice = vm_alloc(vm, BYTE_VECTOR);
    slice->type = BYTE_VECTOR;

    slice->value.byte_vector.length = string->value.string.length;
    slice->value.byte_vector.vector = (uint8_t *)string->value.string.bytes;

    vm_push(vm, vm->reg2);
}

/* Return a string from a bytevector. */
void op_byte_vector_string(vm_internal_type *vm) {
    object_type *vector = 0;
    
    vm->reg1 = vector = vm_pop(vm);

    if (vector->type != BYTE_VECTOR) {
        throw(vm, "u8->str requires a bytevector argument.", 1, vector);
        return;
    }

    vm->reg2 = vm_make_string(
        vm, (char *)vector->value.byte_vector.vector, vector->value.byte_vector.length);

    vm_push(vm, vm->reg2);

}
