#include "vm_instructions_internal.h"
#include "vm_math.h" 

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

