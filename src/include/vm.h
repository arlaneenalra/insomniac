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
object_type *vm_make_byte_vector(vm_type *vm_void, vm_int length);
object_type *vm_make_record(vm_type *vm_void, vm_int length);

#include "utf8.h"

/* interface definitions for external libraries */
typedef void (*ext_call_type)(vm_type *vm, gc_type *gc);

typedef struct binding {
    char *symbol;
    ext_call_type func;
} binding_type;

/* This is a nightmarish hack to allow an unmanaged pointer to be passed
   scheme code. */
#define UNSTUFF_POINTER(pointer, type)                              \
    *(type*)(pointer->value.byte_vector.vector)

#define STUFF_POINTER(vm, pointer, type)                            \
({                                                                  \
    object_type *obj = vm_make_byte_vector(vm, sizeof (type));      \
    type* f = (type*)(obj->value.byte_vector.vector);               \
    *f = pointer;                                                   \
    obj;                                                            \
})


#define STUFFED_POINTER_OP(fn_name, pointer, type)                  \
void fn_name(vm_type *vm, gc_type *gc) {                            \
    object_type *obj = 0;                                           \
    gc_register_root(gc, (void **)&obj);                            \
                                                                    \
    /* We can ignore this. */                                       \
    vm_pop(vm);                                                     \
    obj = STUFF_POINTER(vm, pointer, type);                         \
    vm_push(vm, obj);                                               \
                                                                    \
    gc_unregister_root(gc, (void **)&obj);                          \
}

#define STUFF_FILE_POINTER(fn_name, pointer) STUFFED_POINTER_OP(fn_name, pointer, FILE *)

#endif
