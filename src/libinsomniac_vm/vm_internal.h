#ifndef _VM_INTERNAL_
#define _VM_INTERNAL_

#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>


#include <gc.h>
#include <ops.h>
#include <vm.h>

typedef struct vm_internal vm_internal_type;

typedef void (*fn_type)(vm_internal_type *vm);


struct vm_internal {
 
    object_type *stack_root;

    object_type *symbols; /* a linked list of symols */

    gc_type *gc;

    /* some objects that we only need one instance of */
    object_type *empty; /* The empty object */

    object_type *true; /* True and False objects */
    object_type *false;

    gc_type_def types[CELL_MAX]; /* mapping between cell types and gc types */
    
    fn_type ops[256]; /* bindings for each op code */
    
    /* current execution state */
    uint8_t *code_ref;
    size_t ip;
};

/* construct a new pair */
object_type *cons(vm_type *vm, object_type *car, object_type *cdr);

void create_types(vm_internal_type *vm);
gc_type_def create_vm_type(gc_type *gc);

void setup_instructions(vm_internal_type *vm);

/* output funcitons */
void output_object(FILE *fout, object_type *obj);

#endif
