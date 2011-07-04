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

/* duplicate the reference on top of the stack */
void op_dup_ref(vm_internal_type *vm) {
    object_type *obj = 0;

    gc_protect(vm->gc);
    obj = vm_pop(vm);

    vm_push(vm, obj);
    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* drop the top item on the stack */
void op_drop(vm_internal_type *vm) {
    vm_pop(vm);
}

/* Given a string, convert it into a symbol */
void op_make_symbol(vm_internal_type *vm) {
    object_type *obj = 0;
    object_type *string = 0;

    gc_protect(vm->gc);
    
    string = vm_pop(vm);
    
    assert(string && string->type == STRING);

    if(!hash_get(vm->symbol_table,
                string->value.string.bytes, (void **)&obj)) {

        string->type = SYMBOL;
        
        hash_set(vm->symbol_table,
                 string->value.string.bytes, string);
        obj = string;
    }
    
    vm_push(vm, obj);

    gc_unprotect(vm->gc);
}

/* load a string litteral and push it onto the stack*/
void op_lit_string(vm_internal_type *vm) {
    object_type *obj = 0;
    vm_int length = 0;
    char *str_start = 0;
    
    /* retrieve the length value */
    length = parse_int(vm);

    gc_protect(vm->gc);

    /* pull in the actuall string bytes */
    str_start = (char *)&(vm->env->code_ref[vm->env->ip]);
    obj = vm_make_string(vm, str_start, length);

    vm_push(vm, obj);

    gc_unprotect(vm->gc);
    
    vm->env->ip += length;
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

/* straight jump */
void op_jmp(vm_internal_type *vm) {
    vm_int target = parse_int(vm);
    
    vm->env->ip += target;
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

    gc_register_root(vm->gc, (void **)&value);
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

    gc_register_root(vm->gc, (void **)&value);
    gc_unregister_root(vm->gc, (void **)&key);    
}

/* setup of instructions in given vm instance */
void setup_instructions(vm_internal_type *vm) {

    vm->ops[OP_LIT_FIXNUM] = &op_lit_64bit;
    vm->ops[OP_LIT_EMPTY] = &op_lit_empty;
    vm->ops[OP_LIT_CHAR] = &op_lit_char;
    vm->ops[OP_LIT_STRING] = &op_lit_string;
    vm->ops[OP_MAKE_SYMBOL] = &op_make_symbol;

    vm->ops[OP_MAKE_VECTOR] = &op_make_vector;
    vm->ops[OP_VECTOR_SET] = &op_vector_set;
    vm->ops[OP_VECTOR_REF] = &op_vector_ref;

    vm->ops[OP_LIT_TRUE] = &op_lit_true;
    vm->ops[OP_LIT_FALSE] = &op_lit_false;

    vm->ops[OP_CONS] = &op_cons;

    vm->ops[OP_BIND] = &op_bind;
    vm->ops[OP_READ] = &op_read;


    /* stack operations */
    vm->ops[OP_SWAP] = &op_swap;
    vm->ops[OP_DUP_REF] = &op_dup_ref;
    vm->ops[OP_DROP] = &op_drop;
    vm->ops[OP_OUTPUT] = &op_output;

    /* jump operations */
    vm->ops[OP_JMP] = &op_jmp;
    vm->ops[OP_JNF] = &op_jnf;
}
