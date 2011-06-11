#include "vm_internal.h"

/* parse an integer in byte code form */
vm_int parse_int(vm_internal_type *vm) {
    vm_int num = 0;
    uint8_t byte = 0;
    
    /* ip should be pointed at the instructions argument */
    for(int i=7; i>=0; i--) {
        byte = vm->code_ref[vm->ip + i];
        
        num = num << 8;
        num = num | byte;
    }

    /* increment the ip field */
    vm->ip += 8;
    return num;
}


/* decode an integer literal and push it onto the stack */
void op_lit_64bit(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int num = 0;

    num = parse_int(vm);

    gc_protect(vm->gc);
    
    obj = vm_alloc(vm, FIXNUM);
    obj->value.integer = num;

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* decode a character literal and push it onto the stack */
void op_lit_char(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_char character = 0;
    uint8_t byte = 0;

    /* ip should be pointed at the instructions argument */
    for(int i=4; i>=0; i--) {
        byte = vm->code_ref[vm->ip + i];
        
        character = character << 8;
        character = character | byte;
    }

    /* increment the ip field */
    vm->ip += 4;

    gc_protect(vm->gc);
    
    obj = vm_alloc(vm, CHAR);
    obj->value.character = character;

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* push the empty object onto the stack */
void op_lit_empty(vm_internal_type *vm) {
    vm_push(vm, vm->empty);
}

/* push a true object onto the stack */
void op_lit_true(vm_internal_type *vm) {
    vm_push(vm, vm->true);
}

/* push a true object onto the stack */
void op_lit_false(vm_internal_type *vm) {
    vm_push(vm, vm->false);
}
 

/* cons the top two objects on the stack */
void op_cons(vm_internal_type *vm) {
    object_type *car = 0;
    object_type *cdr = 0;
    object_type *pair = 0;

    gc_protect(vm->gc);

    car = vm_pop(vm);
    cdr = vm_pop(vm);

    pair = cons(vm, car, cdr);

    vm_push(vm, pair);

    gc_unprotect(vm->gc);
}

/* load a string litteral and push it onto the stack*/
void op_lit_string(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    char *str_start = 0;
    
    /* retrieve the length value */
    length = parse_int(vm);

    gc_protect(vm->gc);

    /* pull in the actuall string bytes */
    str_start = (char *)&(vm->code_ref[vm->ip]);
    obj = vm_make_string(vm, str_start, length);

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
    
    vm->ip += length;
}

/* allocate a new vector */
void op_make_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    
    gc_protect(vm->gc);
    
    obj = vm_pop(vm);

    /* make sure we have a number */
    assert(obj && obj->type == FIXNUM);

    length = obj->value.integer;

    obj = vm_make_vector(vm, length);

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}


/* setup of instructions in given vm instance */
void setup_instructions(vm_internal_type *vm) {

    vm->ops[OP_LIT_FIXNUM] = &op_lit_64bit;
    vm->ops[OP_LIT_EMPTY] = &op_lit_empty;
    vm->ops[OP_LIT_CHAR] = &op_lit_char;
    vm->ops[OP_LIT_STRING] = &op_lit_string;

    vm->ops[OP_MAKE_VECTOR] = &op_make_vector;

    vm->ops[OP_LIT_TRUE] = &op_lit_true;
    vm->ops[OP_LIT_FALSE] = &op_lit_false;

    vm->ops[OP_CONS] = &op_cons;
}
