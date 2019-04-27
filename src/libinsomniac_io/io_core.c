#include "io_internal.h"

#include <stdio.h>


/* Say Hello */
void hello_world(vm_type *vm, gc_type *gc) {
    printf("\nHELLO WORLD!\n");
}

void say_something(vm_type *vm, gc_type *gc) {
    object_type *port = 0;
    FILE *fout = 0;
    object_type *message = 0;

    object_type *obj = 0;

    gc_register_root(gc, (void **)&obj);

    obj = vm_pop(vm);

    /* There should be null checking here. */
    port = obj->value.pair.car;
    message = obj->value.pair.cdr->value.pair.car;

    /* Unstuff the pointer. */
    fout = *(FILE **)(port->value.byte_vector.vector);

    vm_output_object(fout, message);

    vm_push(vm, vm_alloc(vm, EMPTY));

    gc_unregister_root(gc, (void **)&obj);
}

STUFF_FILE_POINTER(get_stdin, stdin)
STUFF_FILE_POINTER(get_stdout, stdout)
STUFF_FILE_POINTER(get_stderr, stderr)

/* setup the export list */
binding_type export_list[] = {
     
    {"stdin", &get_stdin},
    {"stdout", &get_stdout},
    {"stderr", &get_stderr},

    {"io-hello-world", &hello_world},
    {"io-say", &say_something},
    {0,0},
};
