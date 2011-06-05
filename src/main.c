#include <stdio.h>

#include <insomniac.h>


void alloc_obj(gc_type *gc, object_type *root, int count) {
    object_type *obj = 0;
    object_type *num = 0;

    printf("Allocating\n");    
    gc_stats(gc);
    
    for(int i = 0; i < count; i++) {
        gc_protect(gc);

        num=gc_alloc(gc, 0, sizeof(object_type));
        num->type=FIXNUM;

        obj = cons(gc, num, obj);
        root->value.pair.car=obj;  

        gc_unprotect(gc);
    }

    gc_stats(gc);
}

void big_stack(gc_type *gc, vm_type *vm, int count) {
    object_type *num=0;

    printf("Pushing\n");

    gc_stats(gc);
    
    for(int i = 0; i < count; i++) {
        gc_protect(gc);
        
        num=gc_alloc(gc, 0, sizeof(object_type));
        num->type=FIXNUM;

        vm_push(vm, num);
        
        gc_unprotect(gc);
    }
    gc_stats(gc);
}

void clear_stack(gc_type *gc, vm_type *vm) {
    printf("Poping\n");

    gc_stats(gc);
    while(vm_pop(vm)->type != EMPTY) {}
    gc_stats(gc);    
}

int main(int argc, char**argv) {
    object_type *root=0;
    object_type *root_two=0;

        
    printf("Insomniac VM\n");

    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = vm_create(gc);

    for(int i=0; i< 1000; i++) {
        big_stack(gc, vm, 1000);
        clear_stack(gc, vm);
        big_stack(gc, vm, 1000);
        big_stack(gc, vm, 1000);
        big_stack(gc, vm, 1000);
        clear_stack(gc, vm);
    }

    /* root = gc_perm_alloc(gc, PAIR); */
    /* root_two = gc_perm_alloc(gc, PAIR); */

    /* alloc_obj(gc, root_two, 1500); */
    
    /* printf("Sweeping\n"); */
    /* gc_sweep(gc); */
    /* gc_stats(gc); */

    /* printf("Clearing\n"); */
    /* /\* make root a permenant object *\/ */

    /* alloc_obj(gc, root, 1000); */

    /* gc_sweep(gc); */

    /* printf("Clearing\n"); */
    /* root->value.pair.car = 0; */

    /* alloc_obj(gc, root, 1000); */

    /* printf("Sweeping\n"); */
    /* gc_sweep(gc); */
    /* gc_stats(gc); */

    /* gc_de_perm(gc, root); */

    /* printf("Sweeping\n"); */
    /* gc_sweep(gc); */
    /* gc_stats(gc); */

    /* gc_de_perm(gc, root_two); */

    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);
    

    vm_destroy(vm);

    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);

    gc_destroy(gc);

    return 0;
}
