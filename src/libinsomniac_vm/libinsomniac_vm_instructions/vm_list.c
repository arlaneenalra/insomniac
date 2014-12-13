#include "vm_instructions_internal.h"

/* cons the top two objects on the stack */
void op_cons(vm_internal_type *vm) {
    object_type *car = 0;
    object_type *cdr = 0;
    object_type *pair = 0;

    vm->reg1 = car = vm_pop(vm);
    vm->reg2 = cdr = vm_pop(vm);

    vm->reg3 = pair = cons(vm, car, cdr);

    vm_push(vm, pair);
}

/* extract the car from a given pair */
void op_car(vm_internal_type *vm) {
    object_type *obj = 0;
    
    vm->reg1 = obj = vm_pop(vm);

    if(obj && obj->type == PAIR) {

        vm->reg1 = obj = obj->value.pair.car;
        vm_push(vm,obj);

    } else {
        
        throw(vm, "Attempt to read the car of a non-pair", 1, obj);
    }
}

/* extract the car from a given pair */
void op_cdr(vm_internal_type *vm) {
    object_type *obj = 0;
    
    vm->reg1 = obj = vm_pop(vm);

    if(obj && obj->type == PAIR) {

        vm->reg1 = obj = obj->value.pair.cdr;
        vm_push(vm,obj);

    } else {

        throw(vm, "Attempt to read the cdr of a non-pair", 1, obj);
    }
}

/* extract the car from a given pair */
void op_set_car(vm_internal_type *vm) {
    object_type *pair = 0;
    object_type *obj = 0;

    vm->reg1 = obj = vm_pop(vm);
    vm->reg2 = pair = vm_pop(vm);

    if(obj && pair && pair->type == PAIR) {

        pair->value.pair.car = obj;

        vm_push(vm, pair);

    } else {
        throw(vm, "Attempt to set the car of a non-pair or set car to non-object", 2, obj, pair);
    }
}

/* extract the car from a given pair */
void op_set_cdr(vm_internal_type *vm) {
    object_type *pair = 0;
    object_type *obj = 0;

    vm->reg1 = obj = vm_pop(vm);
    vm->reg2 = pair = vm_pop(vm);

    if(obj && pair && pair->type == PAIR) {

        pair->value.pair.cdr = obj;
        vm_push(vm, pair);

    } else {

        throw(vm, "Attempt to set the cdr of a non-pair or set cdr to non-object", 2, obj, pair);
    }
}
