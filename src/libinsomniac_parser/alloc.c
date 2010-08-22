#include <stdlib.h>

#include "parser_internal.h"

#include "scheme.h"
#include "lexer.h"


/* Create a new scanner wrapper */
scanner_stack_type *alloc_scanner(parser_core_type *parser) {
    
    scanner_stack_type *scanner=
	(scanner_stack_type *)calloc(1, sizeof(scanner_stack_type));

    return scanner;
}

/* setup a lexer instance */
void create_scanner(parser_core_type *parser) {
    
    parser->scanner=alloc_scanner(parser);
    
    yylex_init_extra(parser, &(peek_scanner(parser)));
}

/* Create instances of the global boolean values */
void create_booleans(parser_core_type *parser) {

    /* true and false are defined by macros to be 
       members of parser->boolean */
    true(parser)=gc_alloc_object_type(parser->gc, BOOL);
    true(parser)->value.bool_val=1;
    gc_mark_perm(parser->gc, true(parser));

    false(parser)=gc_alloc_object_type(parser->gc, BOOL);
    false(parser)->value.bool_val=0;
    gc_mark_perm(parser->gc, false(parser));
}

/* Setup the global empty list object */
void create_empty_list(parser_core_type *parser) {
    parser->empty_list=gc_alloc_object_type(parser->gc, TUPLE);
    car(parser->empty_list)=cdr(parser->empty_list)=0;
    gc_mark_perm(parser->gc, parser->empty_list);
}

/* Setup a global end of file marker */
void create_eof_object(parser_core_type *parser) {
    parser->eof_object=gc_alloc_object_type(parser->gc, CHAR);
    gc_mark_perm(parser->gc, parser->eof_object);
}
