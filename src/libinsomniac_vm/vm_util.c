#include "vm_internal.h"

#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

/* return the instruction/byte at the given address */
uint8_t vm_peek(vm_internal_type *vm, vm_int offset) {
    vm_int addr = vm->env->ip + offset;

    if (addr > vm->env->length) {
        return OP_NOP;
    }

    return vm->env->code_ref[addr];
}

/* create a list of pairs */
void cons(vm_type *vm_void, object_type *car, object_type *cdr, object_type **pair_out) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;

    *pair_out = vm_alloc(vm, PAIR);

    (*pair_out)->value.pair.car = car;
    (*pair_out)->value.pair.cdr = cdr;
}

/* parse an integer in byte code form */
vm_int parse_int(vm_internal_type *vm) {
    vm_int num = 0;
    uint8_t byte = 0;

    /* ip should be pointed at the instructions argument */
    for (int i = 7; i >= 0; i--) {
        byte = vm->env->code_ref[vm->env->ip + i];

        num = num << 8;
        num = num | byte;
    }

    /* increment the ip field */
    vm->env->ip += 8;
    return num;
}

/* parse a string */
void parse_string(vm_internal_type *vm, object_type **obj) {
    vm_int length = 0;
    char *str_start = 0;

    /* retrieve the length value */
    length = parse_int(vm);

    /* pull in the actuall string bytes */
    str_start = (char *)&(vm->env->code_ref[vm->env->ip]);
    *obj = vm_make_string(vm, str_start, length);

    /* update ip */
    vm->env->ip += length;
}

/* Either make the given object into a symbol or replace
   it with the symbol version. */
void make_symbol(vm_internal_type *vm, object_type **obj) {
    object_type *obj_target = *obj;

    if (!hash_get_stateful(
        vm->symbol_table,
        obj_target->value.string.bytes,
        (void **)obj,
        &(obj_target->value.string.state))) {

        obj_target->type = SYMBOL;

        hash_set_stateful(
            vm->symbol_table,
            obj_target->value.string.bytes, 
            obj_target,
            &(obj_target->value.string.state));
    }
}

/* Load a file into a string. */
void vm_load_buf(vm_internal_type *vm, char *file, object_type **obj) {
    size_t count = 0;

    *obj = vm_alloc(vm, STRING);

    count = buffer_load_string(vm->gc, file, &((*obj)->value.string.bytes));

    (*obj)->value.string.length = count;
}
