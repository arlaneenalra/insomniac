#ifndef _VM_INSTRUCTIONS_INTERNAL_
#define _VM_INSTRUCTIONS_INTERNAL_

#include <vm_internal.h>

#include <asm.h>
#include <dlfcn.h>

/* literals with the exception of make_symbol */
void op_lit_64bit(vm_internal_type *vm);
void op_lit_char(vm_internal_type *vm);
void op_lit_empty(vm_internal_type *vm);
void op_lit_true(vm_internal_type *vm);
void op_lit_false(vm_internal_type *vm);
void op_lit_string(vm_internal_type *vm);
void op_lit_symbol(vm_internal_type *vm);
void op_make_symbol(vm_internal_type *vm);

/* logical opreations and comparisons */
void op_eq(vm_internal_type *vm);
void op_not(vm_internal_type *vm);

/* vector operations */
void op_make_vector(vm_internal_type *vm);
void op_vector_set(vm_internal_type *vm);
void op_vector_ref(vm_internal_type *vm);

/* list operations */
void op_cons(vm_internal_type *vm);
void op_car(vm_internal_type *vm);
void op_cdr(vm_internal_type *vm);
void op_set_car(vm_internal_type *vm);
void op_set_cdr(vm_internal_type *vm);

#endif
