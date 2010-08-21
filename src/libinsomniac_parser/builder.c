/*
  Code to build an instance of our AST
 */

#include <stdlib.h>
#include <string.h>
#include "parser_internal.h"

void internal_register_roots(parser_core_type *parser);


/* Setup an instance of our parser and allocate all global 
   objects */
parser_core_type *parser_create(gc_core_type *gc) {
    parser_core_type *parser=0;
    
    parser=(parser_core_type *)malloc(sizeof(parser_core_type));
    
    if(parser) {
	bzero(parser, sizeof(parser_core_type));
    }

    /* attach the gc to this parser */
    parser->gc=gc;

    /* Register roots */
    internal_register_roots(parser);

    /* create global one time objects */
    create_booleans(parser);
    create_empty_list(parser);
    create_eof_object(parser);
    

    /* create a new instance of the scanner */
    create_scanner(parser);
    
    return parser;
}


/* cleanup non-garbage collected memory */
void parser_destroy(parser_core_type *parser) {
    
    if(parser) {
	
	/* clean up all scanner instances */
	while(parser->scanner) {
	    pop_parse_state(parser);
	}

	free(parser);
    }

}

/* Register root pointers with the GC */
void internal_register_roots(parser_core_type *parser) {
    gc_core_type *gc=parser->gc;

    gc_register_root(gc, &(true(parser)));
    gc_register_root(gc, &(false(parser)));
    gc_register_root(gc, &(parser->empty_list));
    gc_register_root(gc, &(parser->quote));
    gc_register_root(gc, &(parser->eof_object));		     
    gc_register_root(gc, &(parser->added));
    gc_register_root(gc, &(parser->current));
}

