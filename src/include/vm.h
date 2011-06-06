#ifndef _VM_
#define _VM_

#include "gc.h"


typedef void vm_type;

vm_type *vm_create(gc_type *gc);
void vm_destroy(vm_type *vm);

object_type *vm_alloc(vm_type *vm, cell_type type);

/* interact with vm stack */
void vm_push(vm_type *vm_void, object_type *obj);
object_type *vm_pop(vm_type *vm_void);

object_type *vm_eval(vm_type *vm_void, size_t size, uint8_t *code_ref);

#endif
