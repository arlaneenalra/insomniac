#include "vm_instructions_internal.h"

/* does a simple object equivalence check */
void op_eq(vm_internal_type *vm) {
    object_type *obj1 = 0;
    object_type *obj2 = 0;
    int result = 0;

    vm->reg1 = obj1 = vm_pop(vm);
    vm->reg2 = obj2 = vm_pop(vm);


    /* make sure we have actual objects */
    if((!obj1 || !obj2)
       && (obj1->type != obj2->type)) {
        vm_push(vm, vm->vm_false);
    } else {
        /* Do comparisons for special types */

        switch(obj1->type) {
        case FIXNUM:
            result = obj1->value.integer == obj2->value.integer;
            break;
        case BOOL:
            result = obj1->value.boolean == obj2->value.boolean;
            break;
        case CHAR:
            result = obj1->value.character == obj2->value.character;
            break;
        case STRING:
            result = !strcmp(obj1->value.string.bytes,
                            obj2->value.string.bytes);
            break;
        default:
            result = obj1 == obj2;
            break;
        }

        /* push the result onto the stack */
        vm_push(vm, result ? vm->vm_true : vm->vm_false);
    }

}

/* return the boolean inverse of the given object */
void op_not(vm_internal_type *vm) {
    object_type *obj = 0;
    
    vm->reg1 = obj = vm_pop(vm);

    if(!obj) {
        printf("Stack Underrun!");
        assert(0);
    }

    /* only #f is false */
    if(obj->type == BOOL && !obj->value.boolean) {
        vm_push(vm, vm->vm_true);
    } else {
        vm_push(vm, vm->vm_false);
    }
}
