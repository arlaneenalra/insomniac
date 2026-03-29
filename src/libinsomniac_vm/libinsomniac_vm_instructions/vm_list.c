#include "vm_instructions_internal.h"

/* cons the top two objects on the stack */
void op_cons(vm_internal_type *vm) {
    #define car vm->reg1
    #define cdr vm->reg2
    object_type *result = 0;

    BEGIN_OP;
    gc_register_root(vm->gc, (void **)&result);

    car = vm_pop(vm);
    cdr = vm_pop(vm);

    cons(vm, car, cdr, &result);

    vm_push(vm, result);

    gc_unregister_root(vm->gc, (void **)&result);
    END_OP;
    #undef car
    #undef cdr
}

/* extract the car from a given pair */
void op_car(vm_internal_type *vm) {
    #define obj vm->reg1

    BEGIN_OP;

    obj = vm_pop(vm);

    if (obj && obj->type == PAIR) {

        obj = obj->value.pair.car;
        vm_push(vm, obj);

    } else {

        throw(vm, "Attempt to read the car of a non-pair", 1, obj);
    }

    END_OP;
    #undef obj
}

/* extract the car from a given pair */
void op_cdr(vm_internal_type *vm) {
    #define obj vm->reg1

    BEGIN_OP;

    obj = vm_pop(vm);

    if (obj && obj->type == PAIR) {

        obj = obj->value.pair.cdr;
        vm_push(vm, obj);

    } else {
        throw(vm, "Attempt to read the cdr of a non-pair", 1, obj);
    }

    END_OP;
    #undef obj
}

/* extract the car from a given pair */
void op_set_car(vm_internal_type *vm) {
    #define obj vm->reg1
    #define p vm->reg2

    BEGIN_OP;

    obj = vm_pop(vm);
    p = vm_pop(vm);

    if (obj && p && p->type == PAIR) {

        p->value.pair.car = obj;

        vm_push(vm, p);

    } else {
        throw(
            vm, "Attempt to set the car of a non-pair or set car to non-object", 2, obj,
            p);
    }

    END_OP;
    #undef obj
    #undef p
}

/* extract the car from a given pair */
void op_set_cdr(vm_internal_type *vm) {
    #define obj vm->reg1
    #define p vm->reg2

    BEGIN_OP;

    obj = vm_pop(vm);
    p = vm_pop(vm);

    if (obj && p && p->type == PAIR) {

        p->value.pair.cdr = obj;
        vm_push(vm, p);

    } else {

        throw(
            vm, "Attempt to set the cdr of a non-pair or set cdr to non-object", 2, obj,
            p);
    }

    END_OP;
    #undef obj
    #undef p
}
