#ifndef _VM_INTERNAL_
#define _VM_INTERNAL_

#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>


#include <gc.h>
#include <ops.h>
#include <hash.h>
#include <vm.h>

typedef struct vm_internal vm_internal_type;
typedef struct env env_type;

/* Function pointer for operations */
typedef void (*fn_type)(vm_internal_type *vm);


/* An environment, "stack frame" in a language like
   C */
struct env {
    /* current execution state */
    uint8_t *code_ref;
    size_t ip;

    /* current variable bindings */
    hashtable_type *bindings;

    /* parent environment */
    env_type *parent;
};

/* definition of the VM itself */
struct vm_internal {
 
    object_type *stack_root;
    vm_int depth;

    gc_type *gc;

    /* some objects that we only need one instance of */
    object_type *empty; /* The empty object */

    object_type *true; /* True and False objects */
    object_type *false;

    gc_type_def types[CELL_MAX]; /* mapping between cell types and gc types */
    
    fn_type ops[256]; /* bindings for each op code */

    hashtable_type *symbol_table; /* Symbol table */
    
    /* current execution state */
    gc_type_def env_type;
    env_type *env;
};

/* construct a new pair */
object_type *cons(vm_type *vm, object_type *car, object_type *cdr);

void create_types(vm_internal_type *vm);
gc_type_def create_vm_type(gc_type *gc);

void setup_instructions(vm_internal_type *vm);

/* code for creating or removing new environments */
void push_env(vm_internal_type *vm);
void clone_env(vm_internal_type *vm, env_type *env);
void pop_env(vm_internal_type *vm);

/* output funcitons */
void output_object(FILE *fout, object_type *obj);

#endif
