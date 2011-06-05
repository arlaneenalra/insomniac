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

void create_types(vm_internal_type *vm);

#endif
