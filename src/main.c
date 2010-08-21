#include <stdio.h>

#include <util.h>
#include <parser.h>
#include <gc.h>


/* A simple REPL */
void repl() {

    char buf[2048];
    
    while(1) {
	printf(">");
	scanf("%s",buf);
	
	/* echo the input */
	TRACE(buf);
    }

}

int main(int argc, char**argv) {
    gc_core_type *gc=0;
    object_type *obj=0;
    object_type *obj_walk=0;

    printf("Insomniac Scheme\n");
    
    gc=gc_create();
    parser_core_type *parser=parser_create(gc);

    gc_stats(gc);

    gc_register_root(gc, &obj);

    gc_stats(gc);

    obj_walk=obj=gc_alloc_object(gc);
    obj->type=TUPLE;

    for(int i=100; i>0 ; i-- ) {
	cdr(obj_walk)=gc_alloc_object(gc);
	cdr(obj_walk)->type=TUPLE;
	obj_walk=cdr(obj_walk);
    }


    gc_stats(gc);

    /*    printf("Frist\n");
    gc_sweep(gc);

    gc_stats(gc); */

    obj=0;

    /*    printf("Second\n");
    gc_sweep(gc);

    gc_stats(gc);*/


    printf("CAR\n");

    obj_walk=obj=gc_alloc_object(gc);
    obj->type=TUPLE;

    for(int i=100; i>0 ; i-- ) {
	car(obj_walk)=gc_alloc_object(gc);
	car(obj_walk)->type=TUPLE;
	obj_walk=car(obj_walk);
    }

    obj=gc_alloc_object(gc);
    obj->type=TUPLE;
    cdr(obj)=gc_alloc_object(gc);
    cdr(obj)->type=TUPLE;
    cddr(obj)=gc_alloc_object(gc);
    cddr(obj)->type=TUPLE;

    gc_stats(gc);

    /*    printf("Frist\n");
    gc_sweep(gc);

    gc_stats(gc);

    obj=0;

    printf("Second\n");
    gc_sweep(gc);

    gc_stats(gc);*/
    
    
    
    /*     repl(); */

    parser_destroy(parser);

    gc_destroy(gc);

    return 0;
}
