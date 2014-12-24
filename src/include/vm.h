#ifndef _VM_
#define _VM_

#include "gc.h"

typedef void vm_type;

void vm_create(gc_type *gc, vm_type **vm);
void vm_destroy(vm_type *vm);

object_type *vm_alloc(vm_type *vm, cell_type type);

/* interact with vm stack */
void vm_push(vm_type *vm_void, object_type *obj);
object_type *vm_pop(vm_type *vm_void);

int vm_eval(vm_type *vm_void, size_t size, uint8_t *code_ref);
void vm_reset(vm_type *vm_void);

void vm_output_object(FILE *fout, object_type *obj);

object_type *vm_make_string(vm_type *vm_void, char *buf, vm_int length);
object_type *vm_make_vector(vm_type *vm_void, vm_int length);
object_type *vm_make_record(vm_type *vm_void, vm_int length);

#include "utf8.h"

/* interface definitions for external libraries */
typedef void (*ext_call_type)(vm_type *vm, gc_type *gc);

typedef struct binding {
    char *symbol;
    ext_call_type func;
} binding_type;


#endif
