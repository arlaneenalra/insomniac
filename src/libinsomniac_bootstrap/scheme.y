%define api.pure

%{
#include <stdio.h>
#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

void yyerror(compiler_core_type *compiler, void *scanner, char *s); 

%}

%parse-param {compiler_core_type *compiler}
%param {void *scanner}
/* %parse-param {void *scanner} */
/* %lex-param {void *scanner} */

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

%token AST_SYMBOL

%token SPEC_DEFINE

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
    CLOSE_PAREN    { emit_empty(compiler); (void)pop_state(compiler); }
  | list_next
    DOT
    object         { push_state(compiler, CHAIN); }
    CLOSE_PAREN    { (void)pop_state(compiler); }
  | CLOSE_PAREN    { emit_empty(compiler); (void)pop_state(compiler); }

list:
    OPEN_PAREN     { push_state(compiler, PUSH); }
    list_end       

list_next:
    object         { emit_cons(compiler); push_state(compiler, CHAIN); }

  | object         { emit_cons(compiler); push_state(compiler, CHAIN); }
    list_next      { }

quoted_list:
    QUOTE          { emit_empty(compiler); push_state(compiler, PUSH); }
    object         { 
                     pop_state(compiler);
                     emit_cons(compiler);
                     emit_symbol(compiler, "quote");
                     emit_cons(compiler);
                   }
    
boolean:
    TRUE_OBJ        { emit_bool(compiler, 1); }
  | FALSE_OBJ       { emit_bool(compiler, 0);}

number:
    FIXED_NUMBER    { emit_fixnum(compiler, yyget_text(scanner));  }
  | FLOAT_NUMBER    { /* add_float(compiler, get_text(scanner)); */ }

string_end:
    STRING_CONSTANT { emit_string(compiler, yyget_text(scanner)); }
    DOUBLE_QUOTE
  | DOUBLE_QUOTE    { emit_string(compiler, ""); }

string:
    DOUBLE_QUOTE
    string_end
    
object:
    boolean
  | CHAR_CONSTANT   { emit_char(compiler, yyget_text(scanner)); }
  | string 
  | AST_SYMBOL      { emit_symbol(compiler, yyget_text(scanner)); }
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
    
    ret_val=yyparse(compiler, scanner);


    return ret_val;
}
