#include <stdio.h>

#include <insomniac.h>
#include <ops.h>

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

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = vm_create(gc);

    size_t length=0;
    size_t written=0;
    buffer_type *buf = 0;
    uint8_t *code_ref = 0;

    /* make this a root to the garbage collector */
    gc_register_root(gc, &buf);
    gc_register_root(gc, (void **)&code_ref); 

    buf = buffer_create(gc);

    /* create a fix num */
    for(int i=0; i<70;i++) {
        {
            uint8_t code_ref[]={ EMIT_LIT_FIXNUM(i) };
            buffer_write(buf, code_ref , 9);
        }
        {
            uint8_t code_ref[]={ EMIT_LIT_TRUE };
            buffer_write(buf, code_ref , 1);
        }

        length = buffer_size(buf);
        printf("Size %zu\n", length);
        gc_stats(gc);
    }

    /* create a code ref */
    code_ref = gc_alloc(gc, 0, length);
    written = buffer_read(buf, &code_ref, length);

    printf("Bytes:");
    for(int i=0; i<length; i++) {
        printf("%2x", code_ref[i]);
    }
    printf("\n");

    output_object(vm_eval(vm, length, code_ref));
    printf("\n");



    /* uint8_t code_ref[]={ */
    /*     EMIT_LIT_FIXNUM(5001), /\* 9 bytes *\/ */
    /*     EMIT_LIT_FIXNUM(1),    /\* 9 bytes *\/ */
    /*     EMIT_LIT_FIXNUM(2),    /\* 9 bytes *\/ */
    /*     EMIT_LIT_FIXNUM(3),    /\* 9 bytes *\/ */
    /*     EMIT_LIT_FIXNUM(-5000), /\* 9 bytes *\/ */
    /*     EMIT_LIT_EMPTY,        /\* 1 byte *\/ */
    /*     EMIT_CONS,             /\* 1 byte *\/ */
    /*     EMIT_CONS,             /\* 1 byte *\/ */
    /*     EMIT_CONS,             /\* 1 byte *\/ */
    /*     EMIT_CONS,             /\* 1 byte *\/ */
    /*     EMIT_CONS              /\* 1 byte *\/ */
    /* }; */

    /* length = 51; */


    /* output_object(vm_eval(vm, length, code_ref)); */
    /* printf("\n"); */

    /* vm_reset(vm); */

    /* uint8_t code_ref2[] = { */
    /*     EMIT_LIT_FIXNUM(1), /\* 9 bytes *\/ */
    /*     EMIT_LIT_FIXNUM(2), /\* 9 bytes *\/ */
    /*     EMIT_CONS,          /\* 1 byte *\/ */
    /*     EMIT_LIT_FIXNUM(1), /\* 9 bytes *\/ */
    /*     EMIT_LIT_FIXNUM(2), /\* 9 bytes *\/ */
    /*     EMIT_CONS,          /\* 1 byte *\/ */
    /*     EMIT_CONS,          /\* 1 byte *\/ */
    /*     EMIT_LIT_FALSE,      /\* 1 byte *\/ */
    /*     EMIT_LIT_FALSE,      /\* 1 byte *\/ */
    /*     EMIT_LIT_TRUE      /\* 1 byte *\/ */
    /* }; */
    
    /* length = 42; */

    /* output_object(vm_eval(vm, length, code_ref2)); */
    /* printf("\n"); */

    vm_destroy(vm);
    gc_destroy(gc);

    return 0;
}
