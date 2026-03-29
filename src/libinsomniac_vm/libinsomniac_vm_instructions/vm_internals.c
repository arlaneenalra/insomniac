#include "vm_instructions_internal.h"

/* output the current state of the garbage collector */
void op_gc_stats(vm_internal_type *vm) {
    gc_register_root(vm->gc, (void **)&vm);
    gc_stats(vm->gc, true);
    gc_unregister_root(vm->gc, (void **)&vm);
}
