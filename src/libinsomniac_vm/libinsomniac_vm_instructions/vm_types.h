#ifndef _VM_TYPES_
#define _VM_TYPES_

#define TYPE_TEST(obj_type) vm->reg1->type == obj_type

/* A macro that can be used to define a set of type checks */
#define TYPE_OP(fn_name, type_test)                                                      \
    void fn_name(vm_internal_type *vm) {                                                 \
        BEGIN_OP;                                                                        \
                                                                                         \
        vm->reg1 = vm_pop(vm);                                                           \
                                                                                         \
        if (vm->reg1 && type_test) {                                                     \
            vm_push(vm, vm->vm_true);                                                    \
        } else {                                                                         \
            vm_push(vm, vm->vm_false);                                                   \
        }                                                                                \
                                                                                         \
        END_OP;                                                                          \
    }

#endif
