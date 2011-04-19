#include <stdio.h>

#include <insomniac.h>


void alloc_obj(gc_type *gc, object_type *root, int count) {
    object_type *obj = 0;

    printf("Allocating\n");    
    gc_stats(gc);
    
    for(int i = 0; i < count; i++) {
        gc_protect(gc);

        obj = cons(gc, gc_alloc(gc, FIXNUM), obj);
        root->value.pair.car=obj;  

        gc_unprotect(gc);
    }

    gc_stats(gc);
}

int main(int argc, char**argv) {
    object_type *root=0;
    object_type *root_two=0;
    
    printf("Insomniac VM\n");

    gc_type *gc = gc_create();
    vm_type *vm = vm_create(gc);

    
    root = gc_perm_alloc(gc, PAIR);
    root_two = gc_perm_alloc(gc, PAIR);

    alloc_obj(gc, root_two, 1500);
    
    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);

    printf("Clearing\n");
    /* make root a permenant object */

    alloc_obj(gc, root, 1000);

    gc_sweep(gc);

    printf("Clearing\n");
    root->value.pair.car = 0;

    alloc_obj(gc, root, 1000);

    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);

    gc_de_perm(gc, root);

    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);

    gc_de_perm(gc, root_two);

    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);

    vm_destroy(vm);
    gc_destroy(gc);

    return 0;
}
