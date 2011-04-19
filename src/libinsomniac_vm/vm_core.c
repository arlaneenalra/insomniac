#include "vm_internal.h"

vm_type *vm_create(gc_type *gc) {
    vm_internal_type *vm = (vm_internal_type *)MALLOC(vm_internal_type);
    
    
    vm->gc = gc;
    
    gc_protect(gc);
   
    /* setup the stack */
    gc_register_root(gc, &(vm->stack_root));
    vm->stack_root = cons(gc,
                        gc_alloc(gc, EMPTY),
                        gc_alloc(gc, EMPTY));

    gc_unprotect(gc);

    return (vm_type *)vm;
}


/* Deallocate the vm instance */
void vm_destroy(vm_type *vm_raw) {
    if(vm_raw) {
        vm_internal_type *vm = (vm_internal_type *)vm_raw;

        gc_unregister_root(vm->gc, &(vm->stack_root));

        FREE(vm);
    }
}


