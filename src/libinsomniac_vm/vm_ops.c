#include "vm_internal.h"

/* decode a literal and push it onto the stack */
void op_lit_64bit(vm_internal_type *vm) {
    object_type *obj = 0;
    uint64_t num = 0;
    uint8_t byte = 0;

    /* ip should be pointed at the instructions argument */
    for(int i=7; i>=0; i--) {
        byte = vm->code_ref[vm->ip + i];
        
        num = num << 8;
        num = num | byte;
    }

    /* increment the ip field */
    vm->ip += 8;

    gc_protect(vm->gc);
    
    obj = vm_alloc(vm, FIXNUM);
    obj->value.integer = num;

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* push the empty object onto our stack */
void op_lit_empty(vm_internal_type *vm) {
    vm_push(vm, vm->empty);
}


/* cons the top two objects on the stack */
void op_cons(vm_internal_type *vm) {
    object_type *car = 0;
    object_type *cdr = 0;
    object_type *pair = 0;

    gc_protect(vm->gc);

    cdr = vm_pop(vm);
    car = vm_pop(vm);

    pair = cons(vm, car, cdr);

    vm_push(vm, pair);

    gc_unprotect(vm->gc);
}


/* setup of instructions in given vm instance */
void setup_instructions(vm_internal_type *vm) {

    vm->ops[OP_LIT_FIXNUM] = &op_lit_64bit;
    vm->ops[OP_LIT_EMPTY] = &op_lit_empty;

    vm->ops[OP_CONS] = &op_cons;
}
