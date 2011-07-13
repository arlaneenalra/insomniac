#include "vm_internal.h"

/* parse an integer in byte code form */
vm_int parse_int(vm_internal_type *vm) {
    vm_int num = 0;
    uint8_t byte = 0;
    
    /* ip should be pointed at the instructions argument */
    for(int i=7; i>=0; i--) {
        byte = vm->env->code_ref[vm->env->ip + i];
        
        num = num << 8;
        num = num | byte;
    }

    /* increment the ip field */
    vm->env->ip += 8;
    return num;
}

/* parse a string */
void parse_string(vm_internal_type *vm, object_type **obj) {
    vm_int length = 0;
    char *str_start = 0;

    /* retrieve the length value */
    length = parse_int(vm);

    /* pull in the actuall string bytes */
    str_start = (char *)&(vm->env->code_ref[vm->env->ip]);
    *obj = vm_make_string(vm, str_start, length);

    /* update ip */
    vm->env->ip += length;
}

/* either make the given object into a symbol or replace
   it with the symbol version */
void make_symbol(vm_internal_type *vm, object_type **obj) {
    if(!hash_get(vm->symbol_table,
                 (*obj)->value.string.bytes, (void **)obj)) {

        (*obj)->type = SYMBOL;
        
        hash_set(vm->symbol_table,
                 (*obj)->value.string.bytes, (*obj));
    }

}

/* decode an integer literal and push it onto the stack */
void op_lit_64bit(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int num = 0;

    num = parse_int(vm);

    gc_protect(vm->gc);
    
    obj = vm_alloc(vm, FIXNUM);
    obj->value.integer = num;

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* decode a character literal and push it onto the stack */
void op_lit_char(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_char character = 0;
    uint8_t byte = 0;

    /* ip should be pointed at the instructions argument */
    for(int i=4; i>=0; i--) {
        byte = vm->env->code_ref[vm->env->ip + i];
        
        character = character << 8;
        character = character | byte;
    }

    /* increment the ip field */
    vm->env->ip += 4;

    gc_protect(vm->gc);
    
    obj = vm_alloc(vm, CHAR);
    obj->value.character = character;

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* push the empty object onto the stack */
void op_lit_empty(vm_internal_type *vm) {
    vm_push(vm, vm->empty);
}

/* push a true object onto the stack */
void op_lit_true(vm_internal_type *vm) {
    vm_push(vm, vm->true);
}

/* push a true object onto the stack */
void op_lit_false(vm_internal_type *vm) {
    vm_push(vm, vm->false);
}
 

/* cons the top two objects on the stack */
void op_cons(vm_internal_type *vm) {
    object_type *car = 0;
    object_type *cdr = 0;
    object_type *pair = 0;

    gc_protect(vm->gc);

    car = vm_pop(vm);
    cdr = vm_pop(vm);

    pair = cons(vm, car, cdr);

    vm_push(vm, pair);

    gc_unprotect(vm->gc);
}

/* extract the car from a given pair */
void op_car(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_pop(vm);

    if(obj && obj->type == PAIR) {

        obj = obj->value.pair.car;
    } else {
        printf("Attempt to read the car of a non-pair\n");
        assert(0);
    }

    vm_push(vm,obj);

    gc_unregister_root(vm->gc,(void **)&obj);
}

/* extract the car from a given pair */
void op_cdr(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);

    obj = vm_pop(vm);

    if(obj && obj->type == PAIR) {

        obj = obj->value.pair.cdr;
    } else {
        printf("Attempt to read the cdr of a non-pair\n");
        assert(0);
    }

    vm_push(vm,obj);

    gc_unregister_root(vm->gc,(void **)&obj);
}

/* extract the car from a given pair */
void op_set_car(vm_internal_type *vm) {
    object_type *pair = 0;
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);
    gc_register_root(vm->gc, (void**)&pair);

    obj = vm_pop(vm);
    pair = vm_pop(vm);

    if(obj && pair && pair->type == PAIR) {

        pair->value.pair.car = obj;
    } else {
        printf("Attempt to set the car of a non-pair or set car to non-object\n");
        assert(0);
    }

    vm_push(vm, pair);

    gc_unregister_root(vm->gc,(void **)&pair);
    gc_unregister_root(vm->gc,(void **)&obj);
}

/* extract the car from a given pair */
void op_set_cdr(vm_internal_type *vm) {
    object_type *pair = 0;
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void**)&obj);
    gc_register_root(vm->gc, (void**)&pair);

    obj = vm_pop(vm);
    pair = vm_pop(vm);

    if(obj && pair && pair->type == PAIR) {

        pair->value.pair.cdr = obj;
    } else {
        printf("Attempt to set the cdr of a non-pair or set cdr to non-object\n");
        assert(0);
    }

    vm_push(vm, pair);

    gc_unregister_root(vm->gc,(void **)&pair);
    gc_unregister_root(vm->gc,(void **)&obj);
}


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

/* Given a string, convert it into a symbol */
void op_make_symbol(vm_internal_type *vm) {
    object_type *string = 0;

    gc_register_root(vm->gc, (void **)&string);
    
    string = vm_pop(vm);
    
    assert(string && string->type == STRING);

    make_symbol(vm, &string);

    vm_push(vm, string);

    gc_unregister_root(vm->gc, (void **)&string);
}

/* load a string litteral and push it onto the stack*/
void op_lit_symbol(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void **)&obj);
    
    parse_string(vm, &obj);
    make_symbol(vm, &obj);

    vm_push(vm, obj);

    gc_unregister_root(vm->gc, (void **)&obj);    

}

/* load a string litteral and push it onto the stack*/
void op_lit_string(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void **)&obj);
    
    parse_string(vm, &obj);

    vm_push(vm, obj);

    gc_unregister_root(vm->gc, (void **)&obj);    

}

/* allocate a new vector */
void op_make_vector(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    
    gc_protect(vm->gc);
    
    obj = vm_pop(vm);

    /* make sure we have a number */
    assert(obj && obj->type == FIXNUM);

    length = obj->value.integer;

    obj = vm_make_vector(vm, length);

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* set an element in a vector */
void op_vector_set(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    gc_protect(vm->gc);

    obj_index = vm_pop(vm);
    obj = vm_pop(vm);
    vector = vm_pop(vm);

    assert(obj_index && obj_index->type == FIXNUM);
    
    index = obj_index->value.integer;

    assert(vector && vector->type == VECTOR &&
           vector->value.vector.length >= index);

    /* do the set */
    vector->value.vector.vector[index] = obj;

    gc_unprotect(vm->gc);
}

/* read an element from a vector */
void op_vector_ref(vm_internal_type *vm) {
    object_type *vector = 0;
    object_type *obj_index = 0;
    object_type *obj = 0;
    vm_int index = 0;

    gc_protect(vm->gc);

    obj_index = vm_pop(vm);
    vector = vm_pop(vm);

    assert(obj_index && obj_index->type == FIXNUM);
    
    index = obj_index->value.integer;

    assert(vector && vector->type == VECTOR &&
           vector->value.vector.length >= index);

    /* do the read */
    obj = vector->value.vector.vector[index];

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* a crude output operations */
void op_output(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_pop(vm);
    vm_output_object(stdout, obj);

    gc_unregister_root(vm->gc, (void**)&obj);
}

/* read a single character */
void op_getc(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_register_root(vm->gc, (void**)&obj);
    
    obj = vm_alloc(vm, CHAR);

    /* TODO: make this utf8 compliant */
    obj->value.character = getchar();
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
        printf("Attempt to jump to non-closure");
        output_object(stdout, closure);
        printf("\n");
        assert(0);
    }

    /* clone the closures environment */
    clone_env(vm, &(vm->env), closure->value.closure);

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
        printf("Attempt to bind with non-symbol\n");
        output_object(stdout, key);
        assert(0);
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
        printf("Attempt to read with non-symbol\n");
        output_object(stdout, key);
        assert(0);
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
        printf("Attempt to read undefined symbol\n");
        output_object(stdout, key);
        assert(0);
    }

    vm_push(vm, value);

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
        printf("Attempt to read with non-symbol\n");
        output_object(stdout, key);
        assert(0);
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
        printf("Attempt to set undefined symbol\n");
        output_object(stdout, key);
        assert(0);
    }
    
    gc_unregister_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);    
}


/* does a simple object equivalence check */
void op_eq(vm_internal_type *vm) {
    object_type *obj1 = 0;
    object_type *obj2 = 0;
    int result = 0;

    gc_register_root(vm->gc, (void **)&obj1);
    gc_register_root(vm->gc, (void **)&obj2);

    obj1 = vm_pop(vm);
    obj2 = vm_pop(vm);


    /* make sure we have actual objects */
    if((!obj1 || !obj2)
       && (obj1->type != obj2->type)) {
        vm_push(vm, vm->false);
    } else {
        /* Do comparisons for special types */

        switch(obj1->type) {
        case FIXNUM:
            result = obj1->value.integer == obj2->value.integer;
            break;
        case BOOL:
            result = obj1->value.bool == obj2->value.bool;
            break;
        case CHAR:
            result = obj1->value.character == obj2->value.character;
            break;
        case STRING:
            result = strcmp(obj1->value.string.bytes,
                            obj2->value.string.bytes);
            break;
        default:
            result = obj1 == obj2;
            break;
        }

        /* push the result onto the stack */
        vm_push(vm, result ? vm->true : vm->false);
    }

    
    gc_unregister_root(vm->gc, (void **)&obj2);
    gc_unregister_root(vm->gc, (void **)&obj1);

}

/* return the boolean inverse of the given object */
void op_not(vm_internal_type *vm) {
    object_type *obj = 0;
    
    gc_register_root(vm->gc, (void **)&obj);
    
    obj = vm_pop(vm);

    if(!obj) {
        printf("Stack Underrun!");
        assert(0);
    }

    /* only #f is false */
    if(obj->type == BOOL && !obj->value.bool) {
        vm_push(vm, vm->true);
    } else {
        vm_push(vm, vm->false);
    }

    gc_unregister_root(vm->gc, (void **)&obj);
}

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

NUMERIC_OP(op_add, +)
NUMERIC_OP(op_sub, -)
NUMERIC_OP(op_mul, *)
NUMERIC_OP(op_div, /)
NUMERIC_OP(op_mod, %)


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
        result = vm->true;                              \
    } else {                                            \
        result = vm->false;                             \
    }                                                   \
    vm_push(vm, result);                                \
                                                        \
    gc_unregister_root(vm->gc, (void **)&result);       \
    gc_unregister_root(vm->gc, (void **)&num2);         \
    gc_unregister_root(vm->gc, (void **)&num1);         \
}                                                       \

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

    vm->ops[OP_MAKE_VECTOR] = &op_make_vector;
    vm->ops[OP_VECTOR_SET] = &op_vector_set;
    vm->ops[OP_VECTOR_REF] = &op_vector_ref;

    vm->ops[OP_LIT_TRUE] = &op_lit_true;
    vm->ops[OP_LIT_FALSE] = &op_lit_false;

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
}

