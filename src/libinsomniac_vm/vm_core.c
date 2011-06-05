#include "vm_internal.h"

vm_type *vm_create(gc_type *gc) {
    vm_internal_type *vm = (vm_internal_type *)MALLOC_TYPE(vm_internal_type);
    
    
    vm->gc = gc;
    
    gc_protect(gc);
   
    /* setup the stack */
    gc_register_root(gc, (void **)&(vm->stack_root));
    /* vm->stack_root = gc_alloc(gc, 0, sizeof(object_type)); */
    /* vm->stack_root->type=EMPTY; */
    vm->stack_root = vm_alloc(vm, EMPTY);

    gc_unprotect(gc);

    return (vm_type *)vm;
}


/* Deallocate the vm instance */
void vm_destroy(vm_type *vm_raw) {
    if(vm_raw) {
        vm_internal_type *vm = (vm_internal_type *)vm_raw;

        gc_unregister_root(vm->gc, (void **)&(vm->stack_root));

        FREE(vm);
    }
}

/* push and item onto the vm stack */
void vm_push(vm_type *vm_void, object_type *obj) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;

    gc_protect(vm->gc);
    
    /* push an item onto the stack */
    vm->stack_root = cons(vm->gc, obj, vm->stack_root);

    gc_unprotect(vm->gc);
}

object_type *vm_pop(vm_type *vm_void) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj = 0;

    /* return empty if we are empty */
    if(vm->stack_root->type == EMPTY) {
        return vm->stack_root;
    }

    /* pop the value off */
    obj = vm->stack_root->value.pair.car;
    vm->stack_root=vm->stack_root->value.pair.cdr;

    return obj;
}


/* Deal with cell alloction */
object_type *vm_alloc(vm_type *vm_void, cell_type type) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj=gc_alloc(vm->gc, 0, sizeof(object_type));
    
    obj->type=type;

    return obj;
}
