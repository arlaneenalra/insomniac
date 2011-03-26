#include <stdio.h>

#include <insomniac.h>


int main(int argc, char**argv) {
    printf("Insomniac VM\n");

    gc_type *gc = gc_create();

    for(int i=0; i<1000; i++) {
        object_type *obj=gc_alloc(gc, PAIR);
    }

    gc_destroy(gc);

    return 0;
}
