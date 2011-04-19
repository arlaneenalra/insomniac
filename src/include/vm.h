#ifndef _VM_
#define _VM_

#include "gc.h"


typedef void vm_type;

vm_type *vm_create(gc_type *gc);
void vm_destroy();


#endif
