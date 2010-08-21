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
