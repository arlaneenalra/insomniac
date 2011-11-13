#include "io_internal.h"


/* Say Hello */
void hello_world(vm_type *vm) {
    printf("\nHELLO WORLD!\n");
}


/* setup the export list */
ext_call_type export_list[] = {
    &hello_world,
    0
};
