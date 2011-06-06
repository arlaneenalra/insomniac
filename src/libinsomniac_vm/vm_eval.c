#include "vm_internal.h"


/* Evaluate the given object using the provided vm instance */
object_type *vm_eval(vm_type *vm_void, uint8_t *code_ref) {
    vm_internal_type *vm = (vm_internal_type *)vm_void;
    object_type *obj =0;
    object_type *obj1 =0;

    gc_protect(vm->gc);

    for(int i=0; i< 10; i++) {
        obj = vm_alloc(vm, FIXNUM);
        obj->value.integer = i;

        obj1 = vm_alloc(vm, FIXNUM);
        obj1->value.integer = i*10;
        
        vm_push(vm, cons(vm, obj, obj1));
    }
    
    gc_unprotect(vm->gc);
    return vm->stack_root;
}
