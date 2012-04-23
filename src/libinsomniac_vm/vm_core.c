#include "vm_internal.h"

void vm_create(gc_type *gc, vm_type **vm_ret ) {
    gc_type_def vm_type_def = 0;
    vm_internal_type *vm = 0;

    gc_register_root(gc, (void**)&vm);
    
    vm_type_def = create_vm_type(gc);
    
    /* create a permanent vm object */
    /* vm = gc_alloc_type(gc, 1, vm_type_def); */
    gc_alloc_type(gc, 0, vm_type_def, (void**)&vm);
    
    vm->gc = gc;

    /* attach instructions to the vm */
    setup_instructions(vm);
    

    /* setup types for allocations */
    create_types(vm);
   
    /* setup unique objects */
    vm->empty = vm_alloc(vm, EMPTY);

    vm->true = vm_alloc(vm, BOOL);
    vm->true->value.bool = 1;
    
    vm->false = vm_alloc(vm, BOOL);
    vm->false->value.bool = 0;

    /* setup the stack */
    vm->stack_root = vm->empty;
    vm->depth = 0;

    /* setup a symbol table */
    vm->symbol_table = hash_create_string(gc);

    /* setup a library hash table */
    vm->import_table = hash_create_pointer(gc);

    /* create the initial environment */
    push_env(vm);

    /* save off the vm pointer to our external pointer */
    *vm_ret = vm;

    gc_unregister_root(gc, (void**)&vm);
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

    gc_protect(vm->gc);
    
    /* push an item onto the stack */
    vm->stack_root = cons(vm, obj, vm->stack_root);
    vm->depth++;

    gc_unprotect(vm->gc);
}

object_type *vm_pop(vm_type *vm_void) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;

    /* return 0 if the stack is empty */
    if(vm->stack_root->type == EMPTY) {
        return 0;
    }

    /* pop the value off */
    obj = vm->stack_root->value.pair.car;
    vm->stack_root=vm->stack_root->value.pair.cdr;
    vm->depth--;

    return obj;
}


/* reset a vm instance into a clean state */
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
