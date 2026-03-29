#include "vm_instructions_internal.h"

/* decode an integer literal and push it onto the stack */
void op_lit_64bit(vm_internal_type *vm) {
    #define obj vm->reg1
    vm_int num = 0;

    BEGIN_OP;
    num = parse_int(vm);
    obj = vm_alloc(vm, FIXNUM);
    obj->value.integer = num;
    vm_push(vm, obj);
    END_OP;
    #undef obj
}

/* decode a character literal and push it onto the stack */
void op_lit_char(vm_internal_type *vm) {
    #define obj vm->reg1
    vm_char character = 0;
    uint8_t byte = 0;

    BEGIN_OP;

    /* ip should be pointed at the instructions argument */
    for (int i = 4; i >= 0; i--) {
        byte = vm->env->code_ref[vm->env->ip + i];

        character = character << 8;
        character = character | byte;
    }

    /* increment the ip field */
    vm->env->ip += 4;

    obj = vm_alloc(vm, CHAR);
    obj->value.character = character;

    vm_push(vm, obj);

    END_OP;
    #undef obj
}

/* push the empty object onto the stack */
void op_lit_empty(vm_internal_type *vm) {
    BEGIN_OP;
    vm_push(vm, vm->empty);
    END_OP;
}

/* push a true object onto the stack */
void op_lit_true(vm_internal_type *vm) {
    BEGIN_OP;
    vm_push(vm, vm->vm_true);
    END_OP;
}

/* push a true object onto the stack */
void op_lit_false(vm_internal_type *vm) {
    BEGIN_OP;
    vm_push(vm, vm->vm_false);
    END_OP;
}

/* load a string litteral and push it onto the stack*/
void op_lit_symbol(vm_internal_type *vm) {
    BEGIN_OP;

    parse_string(vm, &vm->reg1);
    make_symbol(vm, &vm->reg1);

    vm_push(vm, vm->reg1);

    END_OP;
}

/* load a string litteral and push it onto the stack*/
void op_lit_string(vm_internal_type *vm) {
    BEGIN_OP;

    parse_string(vm, &vm->reg1);

    vm_push(vm, vm->reg1);

    END_OP;
}

/* Given a string, convert it into a symbol */
void op_make_symbol(vm_internal_type *vm) {
    BEGIN_OP;

    vm->reg1 = vm_pop(vm);

    if (vm->reg1->type != STRING) {
        throw(vm, "Only string can be converted into a symbol.", 1, vm->reg1);
    }

    make_symbol(vm, &vm->reg1);

    vm_push(vm, vm->reg1);

    END_OP;
}
