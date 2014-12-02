#include "vm_internal.h"
#include <stdarg.h>

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>


/* return the instruction/byte at the given address */
uint8_t vm_peek(vm_internal_type *vm, vm_int offset) {
  vm_int addr = vm->env->ip + offset;

  if (addr > vm->env->length) {
    return OP_NOP;
  }

  return vm->env->code_ref[addr];
}

/* create a list of pairs */
object_type *cons(vm_type *vm_void, object_type *car, object_type *cdr) {
    vm_internal_type *vm=(vm_internal_type *)vm_void;
    object_type *new_pair = 0;
    
   /* gc_protect(vm->gc); */
    gc_register_root(vm->gc, (void **)&new_pair);

    new_pair = vm_alloc(vm, PAIR);
    
    new_pair->value.pair.car = car;
    new_pair->value.pair.cdr = cdr;

    gc_unregister_root(vm->gc, (void **)&new_pair);
    /* gc_unprotect(vm->gc); */
    
    return new_pair;
}

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

/* throw an exception */
void throw(vm_internal_type *vm, char *msg, int num, ...) {
    va_list ap;
    object_type *exception = 0;
    object_type *obj = 0;

    /* make the exception */
    gc_register_root(vm->gc, (void **)&exception);
    gc_register_root(vm->gc, (void **)&obj);

    exception = vm->empty;
  
    /* save off any given objects */    
    va_start(ap, num);
    
    for(int i = 0; i < num ; i++) {
        obj = va_arg(ap, object_type *);
        exception = cons(vm, obj, exception);
    }
    
    va_end(ap);

    /* save the current point in the execution */
    obj = vm_alloc(vm, CLOSURE);
    clone_env(vm, (env_type **)&(obj->value.closure), vm->env);
    
    exception = cons(vm, obj, exception);

    /* /\* save the stack *\/ */
    /* exception = cons(vm, vm->stack_root, exception); */

    /* make a string object for the message */
    obj = vm_make_string(vm, msg, strlen(msg));

    /* put everything in a pair */
    exception = cons(vm,  obj, exception);
    
    /* put the exception itself on the stack */
    vm_push(vm, exception);

    gc_unregister_root(vm->gc, (void **)&obj);
    gc_unregister_root(vm->gc, (void **)&exception);

    /* we did not find a handler ! */
    /* go hunting for the exception handler routine */
    while(vm->env && !vm->env->handler) {
        vm->env = vm->env->parent;
    }


    /* did we find a handler ? */
    if(vm->env) {
    clone_env(vm, (env_type **)&(vm->env), vm->env);
        /* disable exception handler while 
           handling exceptions */
        vm->env->handler = 0;
        /* we can assume that if vm is a valid pointer, 
           handler is a valid */
        vm->env->ip = vm->env->handler_addr;
        return;
    }

    /* we did not find a handler ! */
    vm_pop(vm);
    printf("Unhandled Exception: '%s'\n", msg);
    
    printf("Exception:\n");
    output_object(stdout, exception);

    printf("\nCurrent Stack:\n");
    output_object(stdout, vm->stack_root);
    printf("\n");

    assert(0);
}


/* load a file into a string */
void vm_load_buf(vm_internal_type *vm, char *file, object_type **obj) {
    size_t count = 0;

    *obj = vm_alloc(vm, STRING);

    count = buffer_load_string(vm->gc, file, &((*obj)->value.string.bytes));
    
    (*obj)->value.string.length = count;
}

