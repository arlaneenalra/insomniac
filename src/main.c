#include <stdio.h>

#include <insomniac.h>


void big_stack(gc_type *gc, vm_type *vm, int count) {
    object_type *num=0;

    printf("Pushing\n");
    
    for(int i = 0; i < count; i++) {
        gc_protect(gc);
        
        /* num=gc_alloc(gc, 0, sizeof(object_type)); */
        /* num->type=FIXNUM; */
        num = vm_alloc(vm, FIXNUM);

        vm_push(vm, num);
        
        gc_unprotect(gc);
    }
}

void clear_stack(gc_type *gc, vm_type *vm) {
    printf("Popping\n");

    while(vm_pop(vm)->type != EMPTY) {}
}

int main(int argc, char**argv) {
    object_type *root=0;
    object_type *root_two=0;

        
    printf("Insomniac VM\n");

    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = vm_create(gc);

    for(int i=0; i< 10000; i++) {
        big_stack(gc, vm, 100);
        clear_stack(gc, vm);
        big_stack(gc, vm, 100);
        big_stack(gc, vm, 33);
        big_stack(gc, vm, 893);
        clear_stack(gc, vm);
    }

    

    vm_destroy(vm);

    printf("Sweeping\n");
    gc_sweep(gc);
    gc_stats(gc);

    gc_destroy(gc);

    return 0;
}
