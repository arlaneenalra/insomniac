%define api.pure

%{
#include <stdio.h>
#include "parser_internal.h"

#include "scheme.h"
#include "lexer.h"

void yyerror(void *parser, void *scanner, char *s);

%}

/* Hack to get things to compile for now */
/* %parse-param {parser_core_type *parser} */
%parse-param {parser_core_type *parser}

%parse-param {void *scanner}
%lex-param {void *scanner}

%token OPEN_PAREN
%token START_VECTOR
%token CLOSE_PAREN
%token DOT

%token TRUE_OBJ
%token FALSE_OBJ

%token QUOTE
%token DOUBLE_QUOTE

%token STRING_CONSTANT
%token CHAR_CONSTANT

%token FIXED_NUMBER
%token FLOAT_NUMBER

%token SYMBOL

%token END_OF_FILE

%%

expression:
    object         { YYACCEPT; }
  | END_OF_FILE    { end_of_file(parser); YYACCEPT; }

vector_body:
    object         { chain_state(parser); }
  | object         { chain_state(parser); }
    vector_body

vector_end:
    CLOSE_PAREN    { pop_state(parser); add_empty_vector(parser); }
  | vector_body
    CLOSE_PAREN    { pop_state(parser); add_vector(parser); }

vector:
    START_VECTOR   { push_state(parser); }
    vector_end
   
list_end:
    list_next
    CLOSE_PAREN    { pop_state(parser); }
  | CLOSE_PAREN    { pop_state(parser); add_object(parser, parser->empty_list); }

list:
    OPEN_PAREN     { push_state(parser); }
    list_end       

list_next:
    object         { chain_state(parser); }
  | object         { chain_state(parser); }
    list_next
  | object         { chain_state(parser); }
    DOT
    object         { set(parser, CDR); }

quoted_list:
    QUOTE          
    object         { add_quote(parser); }
    
boolean:
    TRUE_OBJ        {  add_object(parser, parser->boolean.true); }
  | FALSE_OBJ       {  add_object(parser, parser->boolean.false);  }

number:
    FIXED_NUMBER    { add_number(parser, get_text(scanner)); }
  | FLOAT_NUMBER    { add_float(parser, get_text(scanner)); }

string_end:
    STRING_CONSTANT { add_string(parser, get_text(scanner)); }
    DOUBLE_QUOTE
  | DOUBLE_QUOTE    { add_string(parser, ""); }

string:
    DOUBLE_QUOTE
    string_end
    
object:
    boolean
  | CHAR_CONSTANT   { add_char(parser, get_text(scanner)); }
  | string 
  | SYMBOL          { add_symbol(parser, get_text(scanner)); }
  | number
  | list
  | quoted_list
  | vector


%%

void yyerror(void *parser, void *scanner, char *s) {

}


int parse_internal(parser_core_type *parser, void *scanner) {
    int ret_val=0;
    int parsing_flag=0;
    
    /* save off the flag */
    parsing_flag=parser->parsing;

    parser->parsing=1;

    ret_val=yyparse(parser, scanner);

    /* put it back to what it was before we started */
    parser->parsing=parsing_flag;

    return ret_val;
}
