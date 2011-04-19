#ifndef _VM_
#define _VM_

#include "gc.h"


typedef void vm_type;

vm_type *vm_create(gc_type *gc);
void vm_destroy(vm_type *vm);

object_type *cons(gc_type *gc, object_type *car, object_type *cdr);

/* interact with vm stack */
void vm_push(vm_type *vm_void, object_type *obj);
object_type *vm_pop(vm_type *vm_void);

#endif
