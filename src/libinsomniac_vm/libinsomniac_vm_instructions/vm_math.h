#ifndef _VM_MATH_
#define _VM_MATH_

/* Math operations */
#define NUMERIC_OP(fn_name, op)                         \
void fn_name(vm_internal_type *vm) {                    \
    object_type *num1 = 0;                              \
    object_type *num2 = 0;                              \
    object_type *result = 0;                            \
                                                        \
    gc_register_root(vm->gc, (void **)&num1);           \
    gc_register_root(vm->gc, (void **)&num2);           \
    gc_register_root(vm->gc, (void **)&result);         \
                                                        \
    /* verify that the firt two objects are number */   \
    num2 = vm_pop(vm);                                  \
    num1 = vm_pop(vm);                                  \
                                                        \
    /* TODO: replace this with sane exception           \
       handler */                                       \
    if(!num1 || num1->type != FIXNUM ||                 \
       !num2 || num2->type != FIXNUM) {                 \
        printf("Attempt to calculate with non-number\n");\
        output_object(stdout,num1);                     \
        printf("\n");                                   \
        output_object(stdout,num2);                     \
        assert(0);                                      \
    }                                                   \
                                                        \
    result = vm_alloc(vm, FIXNUM);                      \
                                                        \
    result->value.integer =                             \
        num1->value.integer op num2->value.integer;     \
    vm_push(vm, result);                                \
                                                        \
    gc_unregister_root(vm->gc, (void **)&result);       \
    gc_unregister_root(vm->gc, (void **)&num2);         \
    gc_unregister_root(vm->gc, (void **)&num1);         \
}                                                       \


#define NUMERIC_LOGIC(fn_name, op)                      \
void fn_name(vm_internal_type *vm) {                    \
    object_type *num1 = 0;                              \
    object_type *num2 = 0;                              \
    object_type *result = 0;                            \
                                                        \
    gc_register_root(vm->gc, (void **)&num1);           \
    gc_register_root(vm->gc, (void **)&num2);           \
    gc_register_root(vm->gc, (void **)&result);         \
                                                        \
    /* verify that the firt two objects are number */   \
    num2 = vm_pop(vm);                                  \
    num1 = vm_pop(vm);                                  \
                                                        \
    /* TODO: replace this with sane exception           \
       handler */                                       \
    if(!num1 || num1->type != FIXNUM ||                 \
       !num2 || num2->type != FIXNUM) {                 \
        printf("Attempt to compare with non-number\n");\
        printf("\"");                                   \
        output_object(stdout,num1);                     \
        printf("\"\n\"");                               \
        output_object(stdout,num2);                     \
        printf("\"\n");                                 \
        assert(0);                                      \
    }                                                   \
                                                        \
    if(num1->value.integer op num2->value.integer) {    \
        result = vm->vm_true;                              \
    } else {                                            \
        result = vm->vm_false;                             \
    }                                                   \
    vm_push(vm, result);                                \
                                                        \
    gc_unregister_root(vm->gc, (void **)&result);       \
    gc_unregister_root(vm->gc, (void **)&num2);         \
    gc_unregister_root(vm->gc, (void **)&num1);         \
}                                                       \

#endif
