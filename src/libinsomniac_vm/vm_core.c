#include "vm_internal.h"

void vm_create(gc_type *gc, vm_type **vm_ret) {
    gc_type_def vm_type_def = 0;
    vm_internal_type *vm = 0;

    gc_register_root(gc, (void **)&vm);

    vm_type_def = create_vm_type(gc);

    /* Create a permanent vm object. */
    gc_alloc_type(gc, 0, vm_type_def, (void **)&vm);

    vm->gc = gc;

    /* Attach instructions to the vm. */
    setup_instructions(vm);

    /* Setup types for allocations. */
    create_types(vm);

    /* Setup unique objects. */
    vm->empty = vm_alloc(vm, EMPTY);

    vm->vm_true = vm_alloc(vm, BOOL);
    vm->vm_true->value.boolean = true;

    vm->vm_false = vm_alloc(vm, BOOL);
    vm->vm_false->value.boolean = false;

    vm->reg1 = vm->reg2 = vm->reg3 = 0;

    /* Setup the stack. */
    vm->stack_root = vm->empty;
    vm->depth = 0;

    vm->exit_status = 0;

    /* Setup a symbol table. */
    hash_create_string(gc, &(vm->symbol_table));

    /* Setup a library hash table. */
    hash_create_string(gc, &(vm->import_table));

    /* Create the initial environment. */
    push_env(vm);

    /* Save off the vm pointer to our external pointer. */
    *vm_ret = vm;

    gc_unregister_root(gc, (void **)&vm);
}

/* Deallocate the vm instance */
void vm_destroy(vm_type *vm_raw) {
    /* if(vm_raw) { */
    /*     vm_internal_type *vm = (vm_internal_type *)vm_raw; */

    /*     /\* mark this object as collectible *\/ */
    /*     gc_de_perm(vm->gc, vm); */
    /* } */
}

/* push and item onto the vm stack */
void vm_push(vm_type *vm_void, object_type *obj) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *pair = 0;

    gc_protect(vm->gc);

    /* push an item onto the stack */
    cons(vm, obj, vm->stack_root, &pair);

    vm->stack_root = pair;
    vm->depth++;

    gc_unprotect(vm->gc);
}

object_type *vm_pop(vm_type *vm_void) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;

    /* Return 0 if the stack is empty. */
    if (vm->stack_root->type == EMPTY) {
        /* Does not return. */
        throw_fatal(vm, "Stack Under Run!", 0);
    }

    /* Pop the value off. */
    obj = vm->stack_root->value.pair.car;

    /* Make sure our return is not null. */
    if (!obj) {
        throw_fatal(vm, "Null found in pop.", 0);
    }

    vm->stack_root = vm->stack_root->value.pair.cdr;
    vm->depth--;
   

    return obj;
}

/* Reset a vm instance into a clean state. */
void vm_reset(vm_type *vm_void) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;

    vm->stack_root = vm->empty;
    vm->depth = 0;
    vm->env = 0;

    push_env(vm);
}

void vm_output_object(FILE *fout, object_type *obj) {
    output_object(fout, obj); 
}

