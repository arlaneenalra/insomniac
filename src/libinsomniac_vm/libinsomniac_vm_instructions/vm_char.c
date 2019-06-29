#include "vm_instructions_internal.h"

/* convert an integer to a character */
void op_int_to_char(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *ch = 0;

    vm->reg1 = obj = vm_pop(vm);

    if (obj->type != FIXNUM) {
        throw(vm, "Attempt to convert non-number into char", 1, obj);
    } else {
        vm->reg2 = ch = vm_alloc(vm, CHAR);
        
        ch->value.character = (vm_char)obj->value.integer;

        vm_push(vm, ch);
    }
}

/* convert a character to an integer */
void op_char_to_int(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *num = 0;

    vm->reg1 = obj = vm_pop(vm);
    if (obj->type != CHAR) {
        throw(vm, "Attempt to convert non-char into int", 1, obj);
    } else {
        vm->reg2 = num = vm_alloc(vm, FIXNUM);

        num->value.integer = (vm_int) obj->value.character;

        vm_push(vm, num);
    }
}
