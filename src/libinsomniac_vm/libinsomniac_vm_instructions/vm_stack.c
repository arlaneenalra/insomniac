#include "vm_instructions_internal.h"

/* swap the top two items on the stack */
void op_swap(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *obj2 = 0;

    gc_protect(vm->gc);
    
    obj = vm_pop(vm);
    obj2 = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj2);

    gc_unprotect(vm->gc);
}

/* rotate the top two items on the stack */
void op_rot(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *obj2 = 0;
    object_type *obj3 = 0;

    
    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&obj2);
    gc_register_root(vm->gc, (void **)&obj3);

    obj = vm_pop(vm);
    obj2 = vm_pop(vm);
    obj3 = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj3);
    vm_push(vm, obj2);

    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&obj2);
    gc_unregister_root(vm->gc, (void **)&obj3);
}

/* duplicate the reference on top of the stack */
void op_dup_ref(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_protect(vm->gc);
    obj = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* return the current stack depth */
void op_depth(vm_internal_type *vm) {
    object_type *depth = 0;

    gc_register_root(vm->gc, (void **)&depth);
    
    depth = vm_alloc(vm, FIXNUM);
    
    depth->value.integer = vm->depth;
    
    vm_push(vm, depth);

    gc_unregister_root(vm->gc, (void **)&depth);
}

/* drop the top item on the stack */
void op_drop(vm_internal_type *vm) {
    vm_pop(vm);
}
