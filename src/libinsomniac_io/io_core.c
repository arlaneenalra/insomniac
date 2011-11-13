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
ext_call_type export_list[] = {
    &hello_world,
    &say_something,
    0
};
