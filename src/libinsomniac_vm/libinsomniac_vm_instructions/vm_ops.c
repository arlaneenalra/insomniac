#include "vm_instructions_internal.h"
#include "vm_math.h" 

/* swap the top two items on the stack */
void op_swap(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *obj2 = 0;

    gc_protect(vm->gc);
    
    obj = vm_pop(vm);
    obj2 = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj2);

    gc_unprotect(vm->gc);
}

/* rotate the top two items on the stack */
void op_rot(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *obj2 = 0;
    object_type *obj3 = 0;

    
    gc_register_root(vm->gc, (void **)&obj);
    gc_register_root(vm->gc, (void **)&obj2);
    gc_register_root(vm->gc, (void **)&obj3);

    obj = vm_pop(vm);
    obj2 = vm_pop(vm);
    obj3 = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj3);
    vm_push(vm, obj2);

    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&obj2);
    gc_unregister_root(vm->gc, (void **)&obj3);
}

/* duplicate the reference on top of the stack */
void op_dup_ref(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_protect(vm->gc);
    obj = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* return the current stack depth */
void op_depth(vm_internal_type *vm) {
    object_type *depth = 0;

    gc_register_root(vm->gc, (void **)&depth);
    
    depth = vm_alloc(vm, FIXNUM);
    
    depth->value.integer = vm->depth;
    
    vm_push(vm, depth);

    gc_unregister_root(vm->gc, (void **)&depth);
}

/* drop the top item on the stack */
void op_drop(vm_internal_type *vm) {
    vm_pop(vm);
}

/* a crude output operations */
void op_output(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_pop(vm);
    vm_output_object(stdout, obj);

    gc_unregister_root(vm->gc, (void**)&obj);
}

/* load a file and store it in a single string */
void op_slurp(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_pop(vm);

    if(!obj || obj->type != STRING) {
        throw(vm, "Slurp file name not a string!", 1, obj);

    } else {
    
        /* load the file */
        vm_load_buf(vm, obj->value.string.bytes, &obj);
        
        vm_push(vm, obj);
    }

    gc_unregister_root(vm->gc, (void**)&obj);    
}

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

/* read a single character */
void op_getc(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_alloc(vm, CHAR);

    utf8_read_char(&(obj->value.character));
    vm_push(vm, obj);

    gc_unregister_root(vm->gc, (void**)&obj);
    
}


/* jump if the top of stack is not false */
void op_jnf(vm_internal_type *vm) {
    object_type *obj =0 ;
    vm_int target = parse_int(vm);
    
    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_pop(vm);

    if(!(obj && obj->type == BOOL &&
         !obj->value.bool)) {
        vm->env->ip += target;
    }

    gc_unregister_root(vm->gc, (void**)&obj);
}

/* straight jump */
void op_jmp(vm_internal_type *vm) {
    vm_int target = parse_int(vm);
    
    vm->env->ip += target;
}

/* set the exception handler for the current 
   environment */
void op_continue(vm_internal_type *vm) {
    vm_int target = parse_int(vm);

    /* we need an absolute address for the 
       exception handler as we don't know 
       where it will be called from */

    vm->env->handler = 1;
    vm->env->handler_addr = vm->env->ip + target;
}

/* set the exception handler for the current 
   environment */
void op_restore(vm_internal_type *vm) {
    /* restore the current exception handler */
    vm->env->handler = 1;
}


/* create a procedure reference based on the current address
 and jump to target */
void op_call(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* get target address */

    gc_register_root(vm->gc, (void **)&closure);

    /* allocate a new closure */
    closure = vm_alloc(vm, CLOSURE);

    /* save our current environment */
    closure->value.closure = vm->env;
    vm_push(vm, closure);

    gc_unregister_root(vm->gc, (void **)&closure);

    push_env(vm); /* create a child of the current env */

    /* Do the jump */
    vm->env->ip += target;
}

/* create a procedure reference based on target and leave it 
 on the stack*/
void op_proc(vm_internal_type *vm) {
    object_type *closure = 0;
    vm_int target = parse_int(vm); /* get target address */
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&closure);
    gc_register_root(vm->gc, (void **)&env);

    /* allocate a new closure */
    closure = vm_alloc(vm, CLOSURE);

    /* save our current environment */
    clone_env(vm, (env_type **)&env, vm->env);
    /* push_env(vm); */
    /* env = vm->env; */
    /* pop_env(vm); */

    /* update the ip */
    env->ip +=target;
    
    closure->value.closure = env;

    vm_push(vm, closure);

    gc_unregister_root(vm->gc, (void **)&env);
    gc_unregister_root(vm->gc, (void **)&closure);

}

/* jump indirect operation */
void op_jin(vm_internal_type *vm) {
    object_type *closure = 0;
    
    gc_register_root(vm->gc, (void **)&closure);
    
    closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure);
    }

    gc_unregister_root(vm->gc, (void **)&closure);
}

/* call indirect operation */
void op_call_in(vm_internal_type *vm) {
    object_type *closure = 0;
    object_type *ret = 0;
    
    gc_register_root(vm->gc, (void **)&closure);
    gc_register_root(vm->gc, (void **)&ret);
    
    closure = vm_pop(vm);

    if(!closure || closure->type != CLOSURE) {
        throw(vm, "Attempt to jump to non-closure", 1, closure);

    } else {
        /* allocate a new closure */
        ret = vm_alloc(vm, CLOSURE);

        /* save our current environment */
        ret->value.closure = vm->env;
        vm_push(vm, ret);

        /* clone the closures environment */
        clone_env(vm, &(vm->env), closure->value.closure);
        /* create a child environment */
        push_env(vm);
    }

    gc_unregister_root(vm->gc, (void **)&ret);
    gc_unregister_root(vm->gc, (void **)&closure);
}

/* bind a new location in the current environment */
void op_bind(vm_internal_type *vm) {
    object_type *key = 0;
    object_type *value = 0;
    
    gc_register_root(vm->gc, (void **)&key);
    gc_register_root(vm->gc, (void **)&value);

    key = vm_pop(vm);
    value = vm_pop(vm);

    /* make sure the key is a symbol */
    if(key && key->type == SYMBOL) {
        /* do the actual bind */
        hash_set(vm->env->bindings, 
                 key->value.string.bytes,
                 value);
    } else {
        throw(vm, "Attempt to bind with non-symbol", 2, key, value);
    }

    gc_unregister_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);
}

void op_read(vm_internal_type *vm) {
    object_type *key = 0;
    object_type *value = 0;
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&key);
    gc_register_root(vm->gc, (void **)&value);

    key = vm_pop(vm);

    /* make sure the key is a symbol */
    if(!key  || key->type != SYMBOL) {
        throw(vm,"Attempt to read with non-symbol", 1, key);
        
        /* there has to be a better way to do this */
        gc_unregister_root(vm->gc, (void **)&value);
        gc_unregister_root(vm->gc, (void **)&key);
        return;
    }

    /* search all environments and parents for
       key */
    env = vm->env;
    while(env && !hash_get(env->bindings,
                           key->value.string.bytes,
                           (void**)&value)) {
        env = env->parent;
    }
    
    /* we didn't find anything */
    if(!value) {
        throw(vm, "Attempt to read undefined symbol", 1, key);

    } else {

        vm_push(vm, value);
    }

    gc_unregister_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);    
}

void op_set(vm_internal_type *vm) {
    object_type *key = 0;
    object_type *value = 0;
    int done = 0;
    env_type *env = 0;

    gc_register_root(vm->gc, (void **)&key);
    gc_register_root(vm->gc, (void **)&value);

    key = vm_pop(vm);
    value = vm_pop(vm);

    /* make sure the key is a symbol */
    if(!key  || key->type != SYMBOL) {
        throw(vm, "Attempt to set with non-symbol", 2, key, value);

        gc_unregister_root(vm->gc, (void **)&value);
        gc_unregister_root(vm->gc, (void **)&key);
        return;
    }

    /* search all environments and parents for
       key */
    env = vm->env;
    while(env && !done) {
        /* did we find a binding for the symbol? */
        if(hash_get(env->bindings,
                    key->value.string.bytes, 0)) {
            done = 1;

            /* save the value */
            hash_set(env->bindings,
                     key->value.string.bytes,
                     value);
        }
        env = env->parent;
    }

    /* don't allow writing of undefined symbols */
    if(!done) {
        throw(vm, "Attempt to set undefined symbol", 2, key, value);
    }
    
    gc_unregister_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);    
}


/* Math operations */
NUMERIC_OP(op_add, +)
NUMERIC_OP(op_sub, -)
NUMERIC_OP(op_mul, *)
NUMERIC_OP(op_div, /)
NUMERIC_OP(op_mod, %)

NUMERIC_LOGIC(op_numeric_equal, ==)
NUMERIC_LOGIC(op_numeric_lt, <)
NUMERIC_LOGIC(op_numeric_gt, >)

/* setup of instructions in given vm instance */
void setup_instructions(vm_internal_type *vm) {

    vm->ops[OP_LIT_FIXNUM] = &op_lit_64bit;
    vm->ops[OP_LIT_EMPTY] = &op_lit_empty;
    vm->ops[OP_LIT_CHAR] = &op_lit_char;
    vm->ops[OP_LIT_STRING] = &op_lit_string;
    vm->ops[OP_LIT_SYMBOL] = &op_lit_symbol;
    vm->ops[OP_MAKE_SYMBOL] = &op_make_symbol;
    vm->ops[OP_LIT_TRUE] = &op_lit_true;
    vm->ops[OP_LIT_FALSE] = &op_lit_false;

    vm->ops[OP_MAKE_VECTOR] = &op_make_vector;
    vm->ops[OP_VECTOR_SET] = &op_vector_set;
    vm->ops[OP_VECTOR_REF] = &op_vector_ref;

    vm->ops[OP_CONS] = &op_cons;
    vm->ops[OP_CAR] = &op_car;
    vm->ops[OP_CDR] = &op_cdr;
    vm->ops[OP_SET_CAR] = &op_set_car;
    vm->ops[OP_SET_CDR] = &op_set_cdr;

    vm->ops[OP_BIND] = &op_bind;
    vm->ops[OP_SET] = &op_set;
    vm->ops[OP_READ] = &op_read;


    /* stack operations */
    vm->ops[OP_SWAP] = &op_swap;
    vm->ops[OP_ROT] = &op_rot;
    vm->ops[OP_DUP_REF] = &op_dup_ref;
    vm->ops[OP_DROP] = &op_drop;
    vm->ops[OP_DEPTH] = &op_depth;

    vm->ops[OP_OUTPUT] = &op_output;
    vm->ops[OP_GETC] = &op_getc;
    vm->ops[OP_SLURP] = &op_slurp;
    vm->ops[OP_ASM] = &op_asm;

    /* math operatins */
    vm->ops[OP_ADD] = &op_add;
    vm->ops[OP_SUB] = &op_sub;
    vm->ops[OP_MUL] = &op_mul;
    vm->ops[OP_DIV] = &op_div;
    vm->ops[OP_MOD] = &op_mod;

    /* numeric logical operations */
    vm->ops[OP_NUMERIC_EQUAL] = &op_numeric_equal;
    vm->ops[OP_NUMERIC_LT] = &op_numeric_lt;
    vm->ops[OP_NUMERIC_GT] = &op_numeric_gt;

    /* Logical operations */
    vm->ops[OP_NOT] = &op_not;
    vm->ops[OP_EQ] = &op_eq;

    /* jump operations */
    vm->ops[OP_JMP] = &op_jmp;
    vm->ops[OP_JNF] = &op_jnf;

    /* procedure operations */
    vm->ops[OP_CALL] = &op_call;
    vm->ops[OP_PROC] = &op_proc;
    vm->ops[OP_JIN] = &op_jin; /* jump indirect */
    vm->ops[OP_CALL_IN] = &op_call_in; /* jump indirect */

    vm->ops[OP_IMPORT] = &op_import; /* dlopen a dll */
    vm->ops[OP_CALL_EXT] = &op_call_ext; /* call an imported function */

    /* Exception Handline */
    vm->ops[OP_CONTINUE] = &op_continue;
    vm->ops[OP_RESTORE] = &op_restore;
}

