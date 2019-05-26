#ifndef _VM_INTERNAL_
#define _VM_INTERNAL_

#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include <gc.h>

#include <buffer.h>
#include <hash.h>
#include <ops.h>
#include <vm.h>

#define OUTPUT_MAX_DEPTH 100
#define OUTPUT_MAX_LENGTH 100

/* Handle library extensions. */
#ifdef __MACH__
#define LIB_EXT ".dylib"
#define LIB_EXT_LEN 6
#else
#define LIB_EXT ".so"
#define LIB_EXT_LEN 3
#endif

typedef struct vm_internal vm_internal_type;
typedef struct env env_type;

/* Function pointer for operations */
typedef void (*fn_type)(vm_internal_type *vm);

/* An environment, "stack frame" in a language like
   C */
struct env {
    /* current execution state */
    uint8_t *code_ref;
    size_t length;
    size_t ip;

    /* current variable bindings */
    hashtable_type *bindings;

    /* exception handler */
    uint8_t handler;
    size_t handler_addr;

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

    object_type *vm_true; /* True and False objects */
    object_type *vm_false;

    /* Used internally to avoid registering roots */
    object_type *reg1;
    object_type *reg2;
    object_type *reg3;

    gc_type_def types[CELL_MAX]; /* mapping between cell types and gc types */

    fn_type ops[256]; /* bindings for each op code */

    hashtable_type *symbol_table; /* Symbol table */

    hashtable_type *import_table; /* Loaded library table */

    /* current execution state */
    gc_type_def env_type;
    env_type *env;

    int exit_status;
};

/* construct a new pair */
void cons(vm_type *vm, object_type *car, object_type *cdr, object_type **pair_out);

vm_int parse_int(vm_internal_type *vm);
void parse_string(vm_internal_type *vm, object_type **obj);
void make_symbol(vm_internal_type *vm, object_type **obj);
void throw(vm_internal_type * vm, char *msg, int num, ...);

void vm_load_buf(vm_internal_type *vm, char *file, object_type **obj);

/* return instruction at the given address */
uint8_t vm_peek(vm_internal_type *vm, vm_int offset);

void create_types(vm_internal_type *vm);
gc_type_def create_vm_type(gc_type *gc);

void setup_instructions(vm_internal_type *vm);

/* code for creating or removing new environments */
void push_env(vm_internal_type *vm);
void clone_env(vm_internal_type *vm, env_type **target, env_type *env, bool cow);
void pop_env(vm_internal_type *vm);

/* output funcitons */
void output_object(FILE *fout, object_type *obj);

void handle_exception(vm_internal_type * vm, char *msg, bool fatal, int num, ...);

#define throw(vm, msg, ...) handle_exception(vm, msg, false, __VA_ARGS__);
#define throw_fatal(vm, msg, ...) handle_exception(vm, msg, true, __VA_ARGS__);

#endif
