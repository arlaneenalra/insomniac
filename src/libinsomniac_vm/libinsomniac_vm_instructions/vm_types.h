#ifndef _VM_TYPES_
#define _VM_TYPES_

/* A macro that can be used to define a set of type checks */
#define TYPE_OP(fn_name, obj_type)                      \
void fn_name(vm_internal_type *vm) {                    \
    object_type *obj = 0;                               \
    gc_register_root(vm->gc, (void **)&obj);            \
                                                        \
    obj = vm_pop(vm);                                   \
                                                        \
    if(obj && obj->type == obj_type) {                  \
        vm_push(vm, vm->true);                          \
    } else {                                            \
        vm_push(vm, vm->false);                         \
    }                                                   \
                                                        \
    gc_unregister_root(vm->gc, (void **)&obj);          \
}                                                       \


#endif
