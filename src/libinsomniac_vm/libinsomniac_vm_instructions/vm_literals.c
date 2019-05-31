#include "vm_instructions_internal.h"

/* decode an integer literal and push it onto the stack */
void op_lit_64bit(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int num = 0;

    num = parse_int(vm);

    vm->reg1 = obj = vm_alloc(vm, FIXNUM);
    obj->value.integer = num;

    vm_push(vm, obj);
}

/* decode a character literal and push it onto the stack */
void op_lit_char(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_char character = 0;
    uint8_t byte = 0;

    /* ip should be pointed at the instructions argument */
    for (int i = 4; i >= 0; i--) {
        byte = vm->env->code_ref[vm->env->ip + i];

        character = character << 8;
        character = character | byte;
    }

    /* increment the ip field */
    vm->env->ip += 4;

    vm->reg1 = obj = vm_alloc(vm, CHAR);
    obj->value.character = character;

    vm_push(vm, obj);
}

/* push the empty object onto the stack */
void op_lit_empty(vm_internal_type *vm) { vm_push(vm, vm->empty); }

/* push a true object onto the stack */
void op_lit_true(vm_internal_type *vm) { vm_push(vm, vm->vm_true); }

/* push a true object onto the stack */
void op_lit_false(vm_internal_type *vm) { vm_push(vm, vm->vm_false); }

/* load a string litteral and push it onto the stack*/
void op_lit_symbol(vm_internal_type *vm) {
    parse_string(vm, &vm->reg1);
    make_symbol(vm, &vm->reg1);

    vm_push(vm, vm->reg1);
}

/* load a string litteral and push it onto the stack*/
void op_lit_string(vm_internal_type *vm) {
    parse_string(vm, &vm->reg1);

    vm_push(vm, vm->reg1);
}

/* Given a string, convert it into a symbol */
void op_make_symbol(vm_internal_type *vm) {
    vm->reg1 = vm_pop(vm);

    if (vm->reg1->type != STRING) {
        throw(vm, "Only string can be converted into a symbol.", 1, vm->reg1); 
    }

    make_symbol(vm, &vm->reg1);

    vm_push(vm, vm->reg1);
}
