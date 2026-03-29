#ifndef _VM_MATH_
#define _VM_MATH_

/* Math operations */
#define NUMERIC_OP(fn_name, op)                                                          \
    void fn_name(vm_internal_type *vm) {                                                 \
        BEGIN_OP;                                                                        \
                                                                                         \
        /* verify that the firt two objects are number */                                \
        vm->reg2 = vm_pop(vm);                                                           \
        vm->reg1 = vm_pop(vm);                                                           \
                                                                                         \
        /* TODO: replace this with sane exception                                        \
           handler */                                                                    \
        if (!vm->reg1 || vm->reg1->type != FIXNUM ||                                     \
            !vm->reg2 || vm->reg2->type != FIXNUM) {                                     \
            throw(vm, "Attempt to calculate with non-number\n", 2,                       \
                  vm->reg1, vm->reg2);                                                   \
            END_OP;                                                                      \
            return;                                                                      \
        }                                                                                \
                                                                                         \
        vm->reg3 = vm_alloc(vm, FIXNUM);                                                 \
                                                                                         \
        vm->reg3->value.integer = vm->reg1->value.integer op vm->reg2->value.integer;   \
        vm_push(vm, vm->reg3);                                                           \
                                                                                         \
        END_OP;                                                                          \
    }

#define NUMERIC_LOGIC(fn_name, op)                                                       \
    void fn_name(vm_internal_type *vm) {                                                 \
        BEGIN_OP;                                                                        \
                                                                                         \
        /* verify that the firt two objects are number */                                \
        vm->reg2 = vm_pop(vm);                                                           \
        vm->reg1 = vm_pop(vm);                                                           \
                                                                                         \
        /* TODO: replace this with sane exception                                        \
           handler */                                                                    \
        if (!vm->reg1 || vm->reg1->type != FIXNUM ||                                     \
            !vm->reg2 || vm->reg2->type != FIXNUM) {                                     \
            throw(vm, "Attempt to compare with non-number\n", 2,                         \
                  vm->reg1, vm->reg2);                                                   \
            END_OP;                                                                      \
            return;                                                                      \
        }                                                                                \
                                                                                         \
        if (vm->reg1->value.integer op vm->reg2->value.integer) {                        \
            vm_push(vm, vm->vm_true);                                                    \
        } else {                                                                         \
            vm_push(vm, vm->vm_false);                                                   \
        }                                                                                \
                                                                                         \
        END_OP;                                                                          \
    }

#endif
