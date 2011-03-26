#include <stdio.h>

#include <insomniac.h>


/* create a list of pairs */
object_type *cons(gc_type *gc, object_type *car, object_type *cdr) {
    object_type *new_pair = 0;
    
    gc_protect(gc);

    new_pair = gc_alloc(gc, PAIR);
    
    new_pair->value.pair.car = car;
    new_pair->value.pair.cdr = cdr;

    gc_unprotect(gc);
    
    return new_pair;
}

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
    
    printf("Insomniac VM\n");

    gc_type *gc = gc_create();

    root = gc_perm_alloc(gc, PAIR);

    alloc_obj(gc, root, 1500);
    
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


    gc_destroy(gc);

    return 0;
}
