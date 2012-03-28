#include "vm_instructions_internal.h"

/* do a dlopen on a dll */
void op_import(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *obj2 = 0;
    object_type *lib = 0;
    object_type *binding_alist = 0;
    void *handle = 0;
    binding_type **export_list = 0;
    char *symbol = 0;
    vm_int func_count = 0;
    char *msg = 0;

    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&obj2);
    gc_register_root(vm->gc, (void **)&lib);
    gc_register_root(vm->gc, (void **)&binding_alist);

    obj = vm_pop(vm);

    if(!obj || obj->type != STRING) {
        throw(vm, "Attempt to import with non-string filename", 1, obj);
    } else {
        /* check if the library has been loaded */
        handle = dlopen(obj->value.string.bytes, RTLD_NOW | RTLD_LOCAL | RTLD_NOLOAD);

        /* load the library if it has not been loaded */
        if(!handle) {
            handle = dlopen(obj->value.string.bytes, RTLD_NOW | RTLD_LOCAL | RTLD_DEEPBIND);
        }


        /* check to make sure we did not run into an error */
        if(!handle) {
            throw(vm, dlerror(), 1, obj);

        } else {
            if(hash_get(vm->import_table, handle, (void**)&lib)) {
                /* if we have already imported this library,
                   return the existing library object */
                vm_push(vm, lib);
                
            } else { 
                lib = vm_alloc(vm, LIBRARY);
           
                dlerror(); /* Clear error states */
                export_list = (binding_type **)dlsym(handle, "export_list");
            
                if((msg = dlerror())) {
                    throw(vm, msg, 1, obj);
                } else {


                    func_count = 0;

                    while(((binding_type *)export_list)[func_count].func) {
                        func_count++;
                    }

                    lib->value.library.handle = handle;
                    lib->value.library.functions = export_list;
                    lib->value.library.func_count = func_count;

                    /* save this library off into the import table. */
                    hash_set(vm->import_table,
                             handle, lib);

                    vm_push(vm, lib);
                }
            }

            /* setup a binding alist so we can bind the exported 
             * symbols to function call values
             */

            binding_alist = vm->empty;
            export_list = lib->value.library.functions;
            func_count = 0;

            /* count the number of functions */
            while(((binding_type *)export_list)[func_count].func) {

                symbol = ((binding_type *)export_list)[func_count].symbol;
                /* create string object */ 
                obj = vm_make_string(vm, 
                                     symbol,
                                     strlen(symbol));

                /* make our string into a symbol */
                make_symbol(vm, &obj);

                /* convert the func_counter into a number */
                obj2 = vm_alloc(vm, FIXNUM);
                obj2->value.integer = func_count;

                /* This may have some vm allocation issues */
                binding_alist = cons(vm,
                                     cons(vm,
                                          obj,
                                          obj2
                                          ),
                                     binding_alist);

                /* increment function count */
                func_count++;
            }
            vm_push(vm, binding_alist);
        }
    }
    
    gc_unregister_root(vm->gc, (void **)&binding_alist);
    gc_unregister_root(vm->gc, (void **)&lib);
    gc_unregister_root(vm->gc, (void **)&obj2);
    gc_unregister_root(vm->gc, (void **)&obj);
}

/* call a function off a given library */
void op_call_ext(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *lib = 0;
    ext_call_type func_ptr = 0;

    vm_int func = 0;

    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&lib);

    obj = vm_pop(vm);
    lib = vm_pop(vm);

    if(!obj || !lib || obj->type != FIXNUM || lib->type != LIBRARY) {
        throw(vm, "Invalid arguments to call_ext", 2, obj, lib);
    } else {

        func = obj->value.integer;

        if(func > lib->value.library.func_count) {
            throw(vm, "Invalid function number", 2, obj, lib);
        } else {

            /* call the function */
            func_ptr = ((binding_type *)lib->value.library.functions)[func].func;
            (*func_ptr)(vm, vm->gc);
        }
    }

    gc_unregister_root(vm->gc, (void **)&lib);
    gc_unregister_root(vm->gc, (void **)&obj);
}

/* assemble a string on the stack into a proc */
void op_asm(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *closure =0;
    env_type *env = 0;

    uint8_t *code_ref = 0;
    size_t written = 0;

    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&closure);
    gc_register_root(vm->gc, (void **)&code_ref);
    gc_register_root(vm->gc, (void **)&env);

    obj = vm_pop(vm);

    if(!obj || obj->type != STRING) {
        throw(vm, "Attempt to assemble non-string", 1, obj);

    } else {
        /* assemble the string */
        written = asm_string(vm->gc, obj->value.string.bytes, &code_ref);
        /* clone the current environment in a 
           closure */
        clone_env(vm, (env_type **)&env, vm->env);

        /* point to the entry point of our 
           assembled code_ref */
        env->code_ref = code_ref;
        env->ip = 0;
        env->length = written;

        closure = vm_alloc(vm, CLOSURE);
        /* save the new closure onto our stack */
        closure->value.closure = env;

        vm_push(vm, closure);
    }

    gc_unregister_root(vm->gc, (void **)&env);
    gc_unregister_root(vm->gc, (void **)&code_ref);
    gc_unregister_root(vm->gc, (void **)&closure);
    gc_unregister_root(vm->gc, (void **)&obj);

}
