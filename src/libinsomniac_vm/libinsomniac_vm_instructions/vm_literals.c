#include "vm_instructions_internal.h"

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
        byte = vm->env->code_ref[vm->env->ip + i];
        
        character = character << 8;
        character = character | byte;
    }

    /* increment the ip field */
    vm->env->ip += 4;

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

/* load a string litteral and push it onto the stack*/
void op_lit_symbol(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void **)&obj);
    
    parse_string(vm, &obj);
    make_symbol(vm, &obj);

    vm_push(vm, obj);

    gc_unregister_root(vm->gc, (void **)&obj);    

}

/* load a string litteral and push it onto the stack*/
void op_lit_string(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void **)&obj);
    
    parse_string(vm, &obj);

    vm_push(vm, obj);

    gc_unregister_root(vm->gc, (void **)&obj);    

}

/* Given a string, convert it into a symbol */
void op_make_symbol(vm_internal_type *vm) {
    object_type *string = 0;

    gc_register_root(vm->gc, (void **)&string);
    
    string = vm_pop(vm);
    
    assert(string && string->type == STRING);

    make_symbol(vm, &string);

    vm_push(vm, string);

    gc_unregister_root(vm->gc, (void **)&string);
}
