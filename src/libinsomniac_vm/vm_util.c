#include "vm_internal.h"


/* create a list of pairs */
object_type *cons(vm_type *vm_void, object_type *car, object_type *cdr) {
    vm_internal_type *vm=(vm_internal_type *)vm_void;
    object_type *new_pair = 0;
    
   /* gc_protect(vm->gc); */
    gc_register_root(vm->gc, (void **)&new_pair);

    new_pair = vm_alloc(vm, PAIR);
    
    new_pair->value.pair.car = car;
    new_pair->value.pair.cdr = cdr;

    gc_unregister_root(vm->gc, (void **)&new_pair);
    /* gc_unprotect(vm->gc); */
    
    return new_pair;
}
