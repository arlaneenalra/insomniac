#include "vm_internal.h"


/* Evaluate the given object using the provided vm instance */
object_type *vm_eval(vm_type *vm_void, size_t length, uint8_t *code_ref) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    uint8_t op_code = 0; /* op code for instructions */
    fn_type op_call = 0; /* function actually called */

    /* setup the ip */
    vm->ip = 0;
    vm->code_ref = code_ref;

    /* iterate over instrcutions */
    while(vm->ip < length) {
        /* load instrcutions */
        op_code = code_ref[vm->ip];
        op_call = vm->ops[op_code];

        
        /* incerement ip so it points to 
           any arguments or the next instructions */
        vm->ip++;

        /* call instruction */
        if(op_call) {
            (*op_call)(vm);
        } else {
            /* Found undefined instruction */
            printf("Undefined instruction! %zu:%i\n", vm->ip - 1, op_code);
        }

    }

    return vm->stack_root;
}