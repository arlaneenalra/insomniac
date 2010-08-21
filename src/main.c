#include <stdio.h>

#include <util.h>
#include <parser.h>
#include <gc.h>


/* A simple REPL */
void repl(parser_core_type *parser) {

    object_type *obj=0;
    int i=2;

    printf("Simple Bootstrapper\n");
    printf("sizeof(object_type) %" PRIi64 "\n", (uint64_t)sizeof(object_type));
    
    while(i--) {

	printf(">");
	
	obj=parse(parser, stdin);
	
	printf("\n");

	output(parser, obj);
    }

}

int main(int argc, char**argv) {
    gc_core_type *gc=0;
    object_type *obj=0;
    object_type *obj_walk=0;

    /* setup our garbage collector and parser */
    gc=gc_create();
    parser_core_type *parser=parser_create(gc);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);

    repl(parser);

    /* gc_register_root(gc, &obj); */

    /* gc_stats(gc); */

    /* obj_walk=obj=gc_alloc_object(gc); */
    /* obj->type=TUPLE; */

    /* for(int i=100; i>0 ; i-- ) { */
    /* 	cdr(obj_walk)=gc_alloc_object(gc); */
    /* 	cdr(obj_walk)->type=TUPLE; */
    /* 	obj_walk=cdr(obj_walk); */
    /* } */


    /* gc_stats(gc); */

    /*    printf("Frist\n");
    gc_sweep(gc);

    gc_stats(gc); */

    obj=0;

    /*    printf("Second\n");
    gc_sweep(gc);

    gc_stats(gc);*/


    /* printf("CAR\n"); */

    /* obj_walk=obj=gc_alloc_object(gc); */
    /* obj->type=TUPLE; */

    /* for(int i=100; i>0 ; i-- ) { */
    /* 	car(obj_walk)=gc_alloc_object(gc); */
    /* 	car(obj_walk)->type=TUPLE; */
    /* 	obj_walk=car(obj_walk); */
    /* } */

    /* obj=gc_alloc_object(gc); */
    /* obj->type=TUPLE; */
    /* cdr(obj)=gc_alloc_object(gc); */
    /* cdr(obj)->type=TUPLE; */
    /* cddr(obj)=gc_alloc_object(gc); */
    /* cddr(obj)->type=TUPLE; */

    /* gc_stats(gc); */

    /*    printf("Frist\n");
    gc_sweep(gc);

    gc_stats(gc);

    obj=0;

    printf("Second\n");
    gc_sweep(gc);

    gc_stats(gc);*/
    
    
    
    /*     repl(); */

    /* clean up the garbage collector and parser */
    parser_destroy(parser);
    gc_destroy(gc);

    return 0;
}
