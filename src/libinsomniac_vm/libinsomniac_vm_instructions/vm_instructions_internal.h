#ifndef _VM_INSTRUCTIONS_INTERNAL_
#define _VM_INSTRUCTIONS_INTERNAL_

#include <vm_internal.h>

#include <asm.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <sys/errno.h>
#include <unistd.h>

#define MIN(a, b) (a > b ? b : a)
#define MAX(a, b) (a > b ? a : b)

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
void op_make_byte_vector(vm_internal_type *vm);
void op_make_record(vm_internal_type *vm);
void op_index_set(vm_internal_type *vm);
void op_index_ref(vm_internal_type *vm);
void op_vector_length(vm_internal_type *vm);
void op_slice(vm_internal_type *vm);

/* list operations */
void op_cons(vm_internal_type *vm);
void op_car(vm_internal_type *vm);
void op_cdr(vm_internal_type *vm);
void op_set_car(vm_internal_type *vm);
void op_set_cdr(vm_internal_type *vm);

/* stack operations */
void op_swap(vm_internal_type *vm);
void op_rot(vm_internal_type *vm);
void op_dup_ref(vm_internal_type *vm);
void op_depth(vm_internal_type *vm);
void op_drop(vm_internal_type *vm);

/* jumps, calls, and associated */
void op_jnf(vm_internal_type *vm);
void op_jmp(vm_internal_type *vm);
void op_call(vm_internal_type *vm);
void op_adopt(vm_internal_type *vm);
void op_proc(vm_internal_type *vm);
void op_ret(vm_internal_type *vm);
void op_jin(vm_internal_type *vm);
void op_call_in(vm_internal_type *vm);
void op_tail_call_in(vm_internal_type *vm);

/* exception handling instructions, in with jump code */
void op_continue(vm_internal_type *vm);
void op_restore(vm_internal_type *vm);

/* some simple io instructions, these will need to be rethought */
void op_output(vm_internal_type *vm);
void op_slurp(vm_internal_type *vm);
void op_fd_read(vm_internal_type *vm);
void op_fd_write(vm_internal_type *vm);
void op_close(vm_internal_type *vm);
void op_open(vm_internal_type *vm);

/* library handling instructions */
void op_import(vm_internal_type *vm);
void op_call_ext(vm_internal_type *vm);
void op_asm(vm_internal_type *vm);

/* location/variable handling code */
void op_bind(vm_internal_type *vm);
void op_read(vm_internal_type *vm);
void op_set(vm_internal_type *vm);

void op_set_exit(vm_internal_type *vm);

/* internals instructions */
void op_gc_stats(vm_internal_type *vm);

#endif
