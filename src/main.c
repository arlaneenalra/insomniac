#include <stdio.h>

#include <util.h>
#include <parser.h>
#include <gc.h>


/* A simple REPL */
void repl(parser_core_type *parser) {

    object_type *obj=0;
    bool running=1;

    printf("Simple Bootstrapper\n");
    printf("sizeof(object_type) %" PRIi64 "\n", (uint64_t)sizeof(object_type));
    
    while(running) {

	printf(">");
	
	obj=parse(parser, stdin);
	
	if(obj==parser->empty_list) {
	    running=0;
	}
	output(parser, obj);

	printf("\n");
    }

}

int main(int argc, char**argv) {
    gc_core_type *gc=0;
    object_type *obj=0;

    /* setup our garbage collector and parser */
    gc=gc_create();
    parser_core_type *parser=parser_create(gc);

    repl(parser);

    obj=0;
    /* clean up the garbage collector and parser */
    parser_destroy(parser);
    gc_stats(gc);
    gc_destroy(gc);

    return 0;
}
