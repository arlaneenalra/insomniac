#include <stdio.h>

#include <insomniac.h>

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

        flag=1;

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
        
    default:
        printf("<Unkown Object>");
        break;
    }
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = vm_create(gc);

    output_object(vm_eval(vm, 0));

    vm_destroy(vm);
    gc_destroy(gc);

    return 0;
}
