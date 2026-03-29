#include "vm_instructions_internal.h"

/* output the current state of the garbage collector */
void op_gc_stats(vm_internal_type *vm) {
    BEGIN_OP;
    gc_stats(vm->gc, true);
    END_OP;
}
