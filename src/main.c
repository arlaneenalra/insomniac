#include <stdio.h>

#include <insomniac.h>
#include <ops.h>

#include <locale.h>
#include <wchar.h>

void output_object(object_type *obj);

void output_pair(object_type *pair) {
    int flag = 0;
    object_type *car = 0;

    printf("(");
    
    do {
        /* print a space only if we are not on 
           the first pair */
        if(flag) {
            printf(" ");
        }

        /* extract the car and cdr */
        car = pair->value.pair.car;
        pair = pair->value.pair.cdr;
        
        /* output the car */
        output_object(car);

        flag = 1;

    } while(pair && pair->type == PAIR);

    /* print a . if need one */
    if(pair && pair->type != EMPTY) {
        printf(" . ");
        output_object(pair);
    }
    
    printf(")");
}

/* display a given object to stdout */
void output_object(object_type *obj) {
    
    /* make sure we have an object */
    if(!obj) {
        printf("<nil>");
        return;
    }

    switch(obj->type) {

    case FIXNUM: /* deal with a standard fixnum */
        printf("%" PRIi64, obj->value.integer);
        break;

    case EMPTY: /* The object is an empty pair */
        printf("()"); 
        break;
        
    case PAIR:
        output_pair(obj);
        break;

    case CHAR:
        printf("#\\%lc", obj->value.character);
        break;

    case BOOL:
        if(obj->value.bool) {
            printf("#t");
        } else {
            printf("#f");
        }
        break;
        
    default:
        printf("<Unkown Object>");
        break;
    }
}

void assemble_work(buffer_type *buf) {
    EMIT_LIT_EMPTY(buf);

    /* create a fix num */
    for(int i=0; i<10;i++) {
        EMIT_LIT_FIXNUM(buf, i);
        EMIT_CONS(buf);
        EMIT_LIT_TRUE(buf);
        EMIT_CONS(buf);
    }

    EMIT_LIT_EMPTY(buf);

    /* create a fix num */
    for(int i=0; i<10;i++) {
        EMIT_LIT_FIXNUM(buf, i);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x03BB);
        EMIT_CONS(buf);
    }

    EMIT_CONS(buf);

}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = vm_create(gc);

    size_t length=0;
    size_t written=0;
    buffer_type *buf = 0;
    uint8_t *code_ref = 0;
    vm_char wref[] = {0x03BB, 0x2660, 0x0000};

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");
    printf("'%lc' lambda\n", 0x03BB);
    printf("'%ls' lambda\n", wref);

    /* make this a root to the garbage collector */
    gc_register_root(gc, &buf);
    gc_register_root(gc, (void **)&code_ref); 

    buf = buffer_create(gc);
    buf = buffer_create(gc);
    buf = buffer_create(gc);

    assemble_work(buf);

    length = buffer_size(buf);
    printf("Size %zu\n", length);
    gc_stats(gc);

    /* create a code ref */
    code_ref = gc_alloc(gc, 0, length);
    written = buffer_read(buf, &code_ref, length);
    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);

    printf("Evaluating\n");

    output_object(vm_eval(vm, length, code_ref));
    printf("\n");

    vm_reset(vm);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);
    printf("Evaluating\n");

    output_object(vm_eval(vm, length, code_ref));
    printf("\n");

    vm_reset(vm);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);
    
    gc_unregister_root(gc, (void **)&code_ref);
    gc_unregister_root(gc, &buf);

    vm_destroy(vm);
    gc_destroy(gc);

    return 0;
}
