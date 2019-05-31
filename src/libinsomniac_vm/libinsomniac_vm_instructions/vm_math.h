#ifndef _VM_MATH_
#define _VM_MATH_

/* Math operations */
#define NUMERIC_OP(fn_name, op)                                                          \
    void fn_name(vm_internal_type *vm) {                                                 \
        object_type *num1 = 0;                                                           \
        object_type *num2 = 0;                                                           \
        object_type *result = 0;                                                         \
                                                                                         \
        /* verify that the firt two objects are number */                                \
        vm->reg2 = num2 = vm_pop(vm);                                                    \
        vm->reg1 = num1 = vm_pop(vm);                                                    \
                                                                                         \
        /* TODO: replace this with sane exception                                        \
           handler */                                                                    \
        if (!num1 || num1->type != FIXNUM || !num2 || num2->type != FIXNUM) {            \
            throw(vm, "Attempt to calculate with non-number\n", 2, num1, num2);          \
            return;                                                                      \
        }                                                                                \
                                                                                         \
        vm->reg3 = result = vm_alloc(vm, FIXNUM);                                        \
                                                                                         \
        result->value.integer = num1->value.integer op num2->value.integer;              \
        vm_push(vm, result);                                                             \
    }

#define NUMERIC_LOGIC(fn_name, op)                                                       \
    void fn_name(vm_internal_type *vm) {                                                 \
        object_type *num1 = 0;                                                           \
        object_type *num2 = 0;                                                           \
        object_type *result = 0;                                                         \
                                                                                         \
        /* verify that the firt two objects are number */                                \
        vm->reg2 = num2 = vm_pop(vm);                                                    \
        vm->reg1 = num1 = vm_pop(vm);                                                    \
                                                                                         \
        /* TODO: replace this with sane exception                                        \
           handler */                                                                    \
        if (!num1 || num1->type != FIXNUM || !num2 || num2->type != FIXNUM) {            \
            throw(vm, "Attempt to compare with non-number\n", 2, num1, num2);            \
            return;                                                                      \
        }                                                                                \
                                                                                         \
        if (num1->value.integer op num2->value.integer) {                                \
            result = vm->vm_true;                                                        \
        } else {                                                                         \
            result = vm->vm_false;                                                       \
        }                                                                                \
        vm_push(vm, result);                                                             \
    }

#endif
