#include <stdlib.h>

#include "parser_internal.h"

#include "scheme.h"
#include "lexer.h"

void push_parse_state(parser_core_type *parser, FILE *fin) {
    
    scanner_stack_type *scanner=alloc_scanner(parser);

    yylex_init_extra(parser, &(scanner->scanner));
    yyset_in(fin, scanner->scanner);

    scanner->previous=parser->scanner;
    parser->scanner=scanner;
}

void pop_parse_state(parser_core_type *parser) {

    scanner_stack_type *previous=0;

    yylex_destroy(peek_scanner(parser));

    previous=peek_previous(parser);

    free(parser->scanner);

    parser->scanner=previous;
}


/* Parse a file */
object_type *parse(parser_core_type *parser, FILE *in) {
    /* reset(interp);*/
    
    yyset_in(in, peek_scanner(parser));
    
    if(parse_internal(parser, peek_scanner(parser))) {
	return 0;
    }

    TRACE("\n")
    
    return parser->added;
}

void add_object(parser_core_type *interp, object_type *obj) {}
void add_char(parser_core_type *interp, char *str) {}
void add_number(parser_core_type *interp, char *str) {}
void add_float(parser_core_type *interp, char *str) {}
void add_string(parser_core_type *interp, char *str) {}
void add_quote(parser_core_type *interp) {}
void add_vector(parser_core_type *interp) {}
void add_empty_vector(parser_core_type *interp) {}
void add_symbol(parser_core_type *interp, char *str) {}

void chain_state(parser_core_type *interp) {}
void push_state(parser_core_type *interp) {}
void pop_state(parser_core_type *interp) {}

void end_of_file(parser_core_type *interp) {}

void set(parser_core_type *interp, setting_type_enum setting) {}

