#ifndef _VM_
#define _VM_

#include "gc.h"


typedef void vm_type;

vm_type *vm_create(gc_type *gc);
void vm_destroy(vm_type *vm);

object_type *cons(gc_type *gc, object_type *car, object_type *cdr);

#endif
