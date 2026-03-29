#include "vm_instructions_internal.h"

/* Allocate a new byte vector. */
void op_make_byte_vector(vm_internal_type *vm) {
#define obj vm->reg1
    vm_int length = 0;

    BEGIN_OP;

    obj = vm_pop(vm);

    /* Make sure we have a number. */
    if (obj->type != FIXNUM) {
        throw(vm, "Make byte vector requires a number argument.", 1, obj);
        END_OP;
        return;
    }

    length = obj->value.integer;

    obj = vm_make_byte_vector(vm, length);

    vm_push(vm, obj);

    END_OP;
#undef obj
}

/* Allocate a new vector. */
void op_make_vector(vm_internal_type *vm) {
#define obj vm->reg1
    vm_int length = 0;

    BEGIN_OP;

    obj = vm_pop(vm);

    /* Make sure we have a number. */
    if (obj->type != FIXNUM) {
        throw(vm, "Make vector requires a number argument.", 1, obj);
        END_OP;
        return;
    }

    length = obj->value.integer;

    obj = vm_make_vector(vm, length);

    vm_push(vm, obj);

    END_OP;
#undef obj
}

/* Allocate a new record. */
void op_make_record(vm_internal_type *vm) {
#define obj vm->reg1
    vm_int length = 0;

    BEGIN_OP;

    obj = vm_pop(vm);

    /* Make sure we have a number. */
    if (obj->type != FIXNUM) {
        throw(vm, "Make record requires a number argument.", 1, obj);
        END_OP;
        return;
    }

    length = obj->value.integer;

    obj = vm_make_record(vm, length);

    vm_push(vm, obj);

    END_OP;
#undef obj
}

/* Return the length of a vector. */
void op_vector_length(vm_internal_type *vm) {
#define obj vm->reg1
#define len vm->reg2

    BEGIN_OP;

    obj = vm_pop(vm);

    if (obj->type != VECTOR && obj->type != BYTE_VECTOR && obj->type != RECORD) {
        throw(vm, "Attempt to read vector length of non-vector!", 1, obj);
        END_OP;
        return;
    }

    len = vm_alloc(vm, FIXNUM);
    len->value.integer = obj->value.vector.length;

    vm_push(vm, len);

    END_OP;
#undef len
#undef obj
}

/* Set an element in a vector. */
void op_index_set(vm_internal_type *vm) {
#define vec vm->reg1
#define obj vm->reg2
#define obj_index vm->reg3
    vm_int index = 0;

    BEGIN_OP;

    vec = vm_pop(vm);
    obj = vm_pop(vm);
    obj_index = vm_pop(vm);

    if (obj_index->type != FIXNUM) {
        throw(vm, "The index must be a number.", 1, obj_index);
        END_OP;
        return;
    }

    index = obj_index->value.integer;

    /* Make sure we have a vector or equivalent. */
    if (!((vec->type == VECTOR ||
        vec->type == RECORD ||
        vec->type == BYTE_VECTOR
        ) && vec->value.vector.length >= index)) {

        throw(vm, "Set by index requires a vector.", 1, vec);
        END_OP;
        return;
    }

    /* Do the set. */
    if (vec->type == VECTOR || vec->type == RECORD) {
        vec->value.vector.vector[index] = obj;
    } else {
        if (obj->type != FIXNUM) {
            throw(vm, "Byte vectors may only contain numbers.", 1, obj);
            END_OP;
            return;
        }
        vec->value.byte_vector.vector[index] = obj->value.integer;
    }

    END_OP;
#undef obj_index
#undef obj
#undef vec
}

/* Read an element from a vector. */
void op_index_ref(vm_internal_type *vm) {
#define vec vm->reg1
#define obj_index vm->reg2
#define obj vm->reg3
    vm_int index = 0;

    BEGIN_OP;

    vec = vm_pop(vm);
    obj_index = vm_pop(vm);

    if (obj_index->type != FIXNUM) {
        throw(vm, "The index must be a number.", 1, obj_index);
        END_OP;
        return;
    }

    index = obj_index->value.integer;


    /* Make sure we have a vector or equivalent. */
    if (!((vec->type == VECTOR ||
        vec->type == RECORD ||
        vec->type == BYTE_VECTOR
        ) && vec->value.vector.length >= index)) {

        throw(vm, "Read by index requires a vector.", 1, vec);
        END_OP;
        return;
    }

    /* Do the read. */
    if (vec->type == VECTOR || vec->type == RECORD) {
        obj = vec->value.vector.vector[index];
    } else {
        /* Read an integer. */
        obj = vm_alloc(vm, FIXNUM);
        obj->value.integer = vec->value.byte_vector.vector[index];
    }

    vm_push(vm, obj);

    END_OP;
#undef obj
#undef obj_index
#undef vec
}

/* return a byte vector of a string. */
void op_string_byte_vector(vm_internal_type *vm) {
#define str vm->reg1
#define slice vm->reg2

    BEGIN_OP;

    str = vm_pop(vm);

    if (str->type != STRING) {
        throw(vm, "str->u8 requires a string argument.", 1, str);
        END_OP;
        return;
    }

    slice = vm_alloc(vm, BYTE_VECTOR);
    slice->type = BYTE_VECTOR;

    slice->value.byte_vector.length = str->value.string.length;
    slice->value.byte_vector.vector = (uint8_t *)str->value.string.bytes;

    vm_push(vm, vm->reg2);

    END_OP;
#undef slice
#undef str
}

/* Return a string from a bytevector. */
void op_byte_vector_string(vm_internal_type *vm) {
#define vec vm->reg1

    BEGIN_OP;

    vec = vm_pop(vm);

    if (vec->type != BYTE_VECTOR) {
        throw(vm, "u8->str requires a bytevector argument.", 1, vec);
        END_OP;
        return;
    }

    vm->reg2 = vm_make_string(
        vm, (char *)vec->value.byte_vector.vector, vec->value.byte_vector.length);

    vm_push(vm, vm->reg2);

    END_OP;
#undef vec
}
