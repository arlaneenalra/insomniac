#include "runtime_internal.h"

extern uint64_t scheme_code_size();
extern uint8_t *scheme_code();

int run_scheme(int argc, char**argv) {
    size_t code_size = (size_t)scheme_code_size();
    uint8_t *code = scheme_code();
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = 0; 
    int ret_value = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");

    /* make this a root to the garbage collector */
    gc_register_root(gc, &vm);

    vm_create(gc, &vm);

    ret_value = vm_eval(vm, code_size, code);
   
    vm_reset(vm);

    /* Shut everything down */
    vm_destroy(vm);
    gc_unregister_root(gc, &vm);
    
    gc_destroy(gc);

    return ret_value;
}
