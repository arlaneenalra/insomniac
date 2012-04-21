%define api.pure

%{
#include <stdio.h>

#include "scheme.h"
#include "lexer.h"

void yyerror(compiler_core_type *compiler, void *scanner, char *s); 

%}

%parse-param {compiler_core_type *compiler}
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
  | END_OF_FILE    { /* end_of_file(compiler);*/ YYACCEPT; }

vector_body:
    object         { /*chain_state(compiler);*/ }
  | object         { /*chain_state(compiler);*/ }
    vector_body

vector_end:
    CLOSE_PAREN    { /* pop_state(compiler); add_empty_vector(compiler); */}
  | vector_body
    CLOSE_PAREN    { /*pop_state(compiler); add_vector(compiler);*/ }

vector:
    START_VECTOR   { /*push_state(compiler);*/ }
    vector_end
   
list_end:
    list_next
    CLOSE_PAREN    { /*pop_state(compiler); */ }
  | CLOSE_PAREN    { /*pop_state(compiler); add_object(compiler, compiler->empty_list);*/}

list:
    OPEN_PAREN     { /*push_state(compiler); */}
    list_end       

list_next:
    object         { /* chain_state(compiler); */}
  | object         { /* chain_state(compiler); */}
    list_next
  | object         { /* chain_state(compiler); */}
    DOT
    object         { /* set(compiler, CDR); */}

quoted_list:
    QUOTE          
    object         { /* add_quote(compiler); */ }
    
boolean:
    TRUE_OBJ        { /* add_object(compiler, compiler->boolean.true); */ }
  | FALSE_OBJ       { /* add_object(compiler, compiler->boolean.false); */ }

number:
    FIXED_NUMBER    { /* add_number(compiler, get_text(scanner)); */ }
  | FLOAT_NUMBER    { /* add_float(compiler, get_text(scanner)); */ }

string_end:
    STRING_CONSTANT { /* add_string(compiler, get_text(scanner)); */}
    DOUBLE_QUOTE
  | DOUBLE_QUOTE    { /* add_string(compiler, ""); */}

string:
    DOUBLE_QUOTE
    string_end
    
object:
    boolean
  | CHAR_CONSTANT   { /* add_char(compiler, get_text(scanner)); */}
  | string 
  | SYMBOL          { /* add_symbol(compiler, get_text(scanner)); */}
  | number
  | list
  | quoted_list
  | vector


%%

void yyerror(compiler_core_type *compiler, void *scanner, char *s) {
    (void)fprintf(stderr,"There was an error parsing %s on line %i\n", 
                  s, yyget_lineno(scanner));
}


int parse_internal(compiler_core_type *compiler, void *scanner) {
    int ret_val=0;
    int parsing_flag=0;
    
    ret_val=yyparse(compiler, scanner);


    return ret_val;
}
