#include "vm_instructions_internal.h"

/* swap the top two items on the stack */
void op_swap(vm_internal_type *vm) {
    
    vm->reg1 = vm_pop(vm);
    vm->reg2 = vm_pop(vm);

    vm_push(vm, vm->reg1);
    vm_push(vm, vm->reg2);
}

/* rotate the top two items on the stack */
void op_rot(vm_internal_type *vm) {

    vm->reg1 = vm_pop(vm);
    vm->reg2 = vm_pop(vm);
    vm->reg3 = vm_pop(vm);

    vm_push(vm, vm->reg1);
    vm_push(vm, vm->reg3);
    vm_push(vm, vm->reg2);

}

/* duplicate the reference on top of the stack */
void op_dup_ref(vm_internal_type *vm) {

    vm->reg1 = vm_pop(vm);

    vm_push(vm, vm->reg1);
    vm_push(vm, vm->reg1);
}

/* return the current stack depth */
void op_depth(vm_internal_type *vm) {
    
    vm->reg1 = vm_alloc(vm, FIXNUM);
    
    vm->reg1->value.integer = vm->depth;
    
    vm_push(vm, vm->reg1);
}

/* drop the top item on the stack */
void op_drop(vm_internal_type *vm) {
    vm_pop(vm);
}
