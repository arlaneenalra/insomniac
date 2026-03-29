#include "vm_instructions_internal.h"

/* convert an integer to a character */
void op_int_to_char(vm_internal_type *vm) {
#define obj vm->reg1
#define ch vm->reg2

    BEGIN_OP;

    obj = vm_pop(vm);

    if (obj->type != FIXNUM) {
        throw(vm, "Attempt to convert non-number into char", 1, obj);
    } else {
        ch = vm_alloc(vm, CHAR);

        ch->value.character = (vm_char)obj->value.integer;

        vm_push(vm, ch);
    }

    END_OP;
#undef obj
#undef ch
}

/* convert a character to an integer */
void op_char_to_int(vm_internal_type *vm) {
#define obj vm->reg1
#define num vm->reg2

    BEGIN_OP;

    obj = vm_pop(vm);
    if (obj->type != CHAR) {
        throw(vm, "Attempt to convert non-char into int", 1, obj);
    } else {
        num = vm_alloc(vm, FIXNUM);

        num->value.integer = (vm_int) obj->value.character;

        vm_push(vm, num);
    }

    END_OP;
#undef obj
#undef num
}
