#include "vm_instructions_interanl.h"

/* cons the top two objects on the stack */
void op_cons(vm_internal_type *vm) {
    object_type *car = 0;
    object_type *cdr = 0;
    object_type *pair = 0;

    gc_protect(vm->gc);

    car = vm_pop(vm);
    cdr = vm_pop(vm);

    pair = cons(vm, car, cdr);

    vm_push(vm, pair);

    gc_unprotect(vm->gc);
}

/* extract the car from a given pair */
void op_car(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_pop(vm);

    if(obj && obj->type == PAIR) {

        obj = obj->value.pair.car;
        vm_push(vm,obj);

    } else {
        
        throw(vm, "Attempt to read the car of a non-pair", 1, obj);
    }


    gc_unregister_root(vm->gc,(void **)&obj);
}

/* extract the car from a given pair */
void op_cdr(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_pop(vm);

    if(obj && obj->type == PAIR) {

        obj = obj->value.pair.cdr;
        vm_push(vm,obj);

    } else {

        throw(vm, "Attempt to read the cdr of a non-pair", 1, obj);
    }

    gc_unregister_root(vm->gc,(void **)&obj);
}

/* extract the car from a given pair */
void op_set_car(vm_internal_type *vm) {
    object_type *pair = 0;
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);
    gc_register_root(vm->gc, (void**)&pair);

    obj = vm_pop(vm);
    pair = vm_pop(vm);

    if(obj && pair && pair->type == PAIR) {

        pair->value.pair.car = obj;

        vm_push(vm, pair);

    } else {
        throw(vm, "Attempt to set the car of a non-pair or set car to non-object", 2, obj, pair);
    }

    gc_unregister_root(vm->gc,(void **)&pair);
    gc_unregister_root(vm->gc,(void **)&obj);
}

/* extract the car from a given pair */
void op_set_cdr(vm_internal_type *vm) {
    object_type *pair = 0;
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);
    gc_register_root(vm->gc, (void**)&pair);

    obj = vm_pop(vm);
    pair = vm_pop(vm);

    if(obj && pair && pair->type == PAIR) {

        pair->value.pair.cdr = obj;
        vm_push(vm, pair);

    } else {

        throw(vm, "Attempt to set the cdr of a non-pair or set cdr to non-object", 2, obj, pair);
    }

    gc_unregister_root(vm->gc,(void **)&pair);
    gc_unregister_root(vm->gc,(void **)&obj);
}
