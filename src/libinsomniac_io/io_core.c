#include "io_internal.h"


/* Say Hello */
void hello_world(vm_type *vm) {
    printf("\nHELLO WORLD!\n");
}


/* setup the export list */
EXPORT_LIST = {
    &hello_world
};
