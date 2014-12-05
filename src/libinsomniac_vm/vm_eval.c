#include "vm_internal.h"


/* Evaluate the given object using the provided vm instance */
int vm_eval(vm_type *vm_void, size_t length, uint8_t *code_ref) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    uint8_t op_code = 0; /* op code for instructions */
    fn_type op_call = 0; /* function actually called */

    /* setup the ip */
    vm->env->ip = 0;
    vm->env->code_ref = code_ref;
    vm->env->length = length;

    /* iterate over instrcutions */
    while(vm->env->ip < vm->env->length) {
        /* load instrcutions */
        op_code = vm->env->code_ref[vm->env->ip];
        op_call = vm->ops[op_code];

        
        /* incerement ip so it points to 
           any arguments or the next instructions */
        vm->env->ip++;

        /* call instruction */
        if(op_call) {
            (*op_call)(vm);
        } else {
            /* Found undefined instruction */
            fprintf(stderr, "Undefined instruction! %zu:%i\n", vm->env->ip - 1, op_code);
        }

    }

    return vm->exit_status;
}
