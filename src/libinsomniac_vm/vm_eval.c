#include "vm_internal.h"

/* Evaluate the given object using the provided vm instance. */
int vm_eval(vm_type *vm_void, size_t length, uint8_t *code_ref,
    debug_range_type *debug, uint64_t debug_count) {

    vm_internal_type *vm = (vm_internal_type *)vm_void;
    uint8_t op_code = 0; /* Op code for instructions. */
    fn_type op_call = 0; /* Function actually called. */

    /* Setup the ip. */
    vm->env->ip = 0;
    vm->env->code_ref = code_ref;
    vm->env->length = length;
    vm->env->debug = debug;
    vm->env->debug_count = debug_count;

    /* Iterate over instrcutions. */
    while (vm->env->ip < vm->env->length) {
        /* Load instrcutions. */
        op_code = vm->env->code_ref[vm->env->ip];
        op_call = vm->ops[op_code];

        /* Incerement ip so it points to any arguments or the next instructions. */
        vm->env->ip++;

        /* Call instruction. */
        if (op_call) {
            (*op_call)(vm);

            /* Clean up after instructions. */
            vm->reg1 = vm->reg2 = vm->reg3 = 0;
        } else {
            throw_fatal(vm, "Found Undefined instrution.", 0);
        }
    }

    return vm->exit_status;
}
