#include "io_internal.h"

#include <stdio.h>


/* Say Hello */
void hello_world(vm_type *vm, gc_type *gc) {
    printf("\nHELLO WORLD!\n");
}

void say_something(vm_type *vm, gc_type *gc) {
    object_type *obj = 0;

    gc_register_root(gc, (void **)&obj);

    obj = vm_pop(vm);

    vm_output_object(stdout, obj);

    gc_unregister_root(gc, (void **)&obj);
}


/* setup the export list */
binding_type export_list[] = {
    {"io-hello-world", &hello_world},
    {"io-say", &say_something},
    {0,0},
};
