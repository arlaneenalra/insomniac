#ifndef _VM_TYPES_
#define _VM_TYPES_

#define TYPE_TEST(obj_type) obj->type == obj_type

/* A macro that can be used to define a set of type checks */
#define TYPE_OP(fn_name, type_test)                     \
void fn_name(vm_internal_type *vm) {                    \
    object_type *obj = 0;                               \
                                                        \
    vm->reg1 = obj = vm_pop(vm);                        \
                                                        \
    if(obj && type_test) {                              \
        vm_push(vm, vm->vm_true);                       \
    } else {                                            \
        vm_push(vm, vm->vm_false);                      \
    }                                                   \
                                                        \
}                                                       \


#endif
