#ifndef _VM_INTERNAL_
#define _VM_INTERNAL_

#include <stddef.h>

#include <gc.h>
#include <ops.h>
#include <vm.h>

typedef struct vm_internal {
 
    object_type *stack_root;
    gc_type *gc;

    gc_type_def types[CELL_MAX]; /* mapping between cell types and gc types */
} vm_internal_type;

/* construct a new pair */
object_type *cons(vm_type *gc, object_type *car, object_type *cdr);

void create_types(vm_internal_type *vm);
gc_type_def create_vm_type(gc_type *gc);

#endif
