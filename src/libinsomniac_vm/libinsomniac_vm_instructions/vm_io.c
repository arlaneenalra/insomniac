#include "vm_instructions_internal.h"

/* read a single character */
void op_getc(vm_internal_type *vm) {
    object_type *obj = 0;

    vm->reg1 = obj = vm_alloc(vm, CHAR);

    utf8_read_char(&(obj->value.character));
    vm_push(vm, obj);

}


/* load a file and store it in a single string */
void op_slurp(vm_internal_type *vm) {
    object_type *obj = 0;

    vm->reg1 = obj = vm_pop(vm);

    if(!obj || obj->type != STRING) {
        throw(vm, "Slurp file name not a string!", 1, obj);

    } else {
    
        /* load the file */
        vm_load_buf(vm, obj->value.string.bytes, &vm->reg1);
        
        vm_push(vm, vm->reg1);
    }
}

/* a crude output operations */
void op_output(vm_internal_type *vm) {
    object_type *obj = 0;

    vm->reg1 = obj = vm_pop(vm);
    vm_output_object(stdout, obj);
}
