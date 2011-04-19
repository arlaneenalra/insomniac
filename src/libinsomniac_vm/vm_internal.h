#ifndef _VM_INTERNAL_
#define _VM_INTERNAL_

#include <gc.h>
#include <ops.h>
#include <vm.h>

typedef struct vm_internal {
 
    object_type *stack_root;
    gc_type *gc;
} vm_internal_type;

#endif
