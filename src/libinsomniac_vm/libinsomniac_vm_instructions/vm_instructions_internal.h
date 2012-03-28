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

#endif
