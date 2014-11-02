%pure-parser 
/* %define api.pure */

%{
#include <stdio.h>
#include "bootstrap_internal.h"
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
%token MATH_OPS

%token AST_SYMBOL

%token PRIM_DISPLAY
%token PRIM_BEGIN
%token PRIM_QUOTE
%token PRIM_DEFINE

%token SPEC_DEFINE

%token END_OF_FILE

%%

top_level:
    expression     { YYACCEPT; }
  | END_OF_FILE    { /* end_of_file(compiler);*/ YYACCEPT; }

self_evaluating:
    boolean
  | CHAR_CONSTANT  { emit_char(compiler, yyget_text(scanner)); }
  | string 
  | number

/* Matches all symbols
   We have to list all of the special case symbols here too
   or the compiler won't know how to handle them when it sees
   them out of context. */
symbol:
    AST_SYMBOL
  | PRIM_DISPLAY
  | PRIM_BEGIN
  | PRIM_QUOTE
  | PRIM_DEFINE
  
literal:
    quoted
  | self_evaluating

expression:
    literal
  | symbol         { /* compile to symbol lookup */
                     emit_symbol(compiler, yyget_text(scanner));
                     emit_op(compiler, "@");
                   } 
  | procedure_call

datum:
      literal
    | symbol       { emit_symbol(compiler, yyget_text(scanner)); }
    | list
   
list_end:
    list_next    
    CLOSE_PAREN    { emit_empty(compiler); (void)pop_state(compiler); }
  | list_next      { emit_cons(compiler); push_state(compiler, CHAIN); } 
    DOT
    datum          { push_state(compiler, CHAIN); }
    CLOSE_PAREN    { (void)pop_state(compiler); }
  | CLOSE_PAREN    { emit_empty(compiler); (void)pop_state(compiler); }

list:
    OPEN_PAREN     { push_state(compiler, PUSH); }
    list_end       

list_next:
    datum          
  | datum
    list_next 

quoted:
    QUOTE
    datum
  | OPEN_PAREN
    PRIM_QUOTE
    datum
    CLOSE_PAREN

    
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
  
/* Some basic math procedures */
procedure_call:
    OPEN_PAREN      { push_state(compiler, PUSH); }
    primitive_procedures { (void)pop_state(compiler); }

primitive_procedures:
    math_calls
  | display
  | begin
  | define

display:
    PRIM_DISPLAY
    expression      { emit_op(compiler, "out"); emit_empty(compiler); }
    CLOSE_PAREN

define:
  define_variable

/* the most basic version of define */
define_variable:
  PRIM_DEFINE
  symbol            {
                      push_state(compiler, PUSH);
                      emit_symbol(compiler, yyget_text(scanner));
                      push_state(compiler, CHAIN);
                    }
  expression        { emit_op(compiler, "dup"); push_state(compiler, CHAIN); }
  CLOSE_PAREN       { 
                      pop_state(compiler);
                      emit_op(compiler, "bind");
                    }
        
begin:
    PRIM_BEGIN
    begin_end

begin_body:
    expression
  | expression      { emit_op(compiler, "drop"); }
    begin_body

begin_end:
    CLOSE_PAREN     { emit_empty(compiler); } 
  | begin_body 
    CLOSE_PAREN

/* Inline mathematical calls */
math_calls:
    MATH_OPS        {
                      emit_op(compiler, "swap");
                      emit_op(compiler, yyget_text(scanner));
                      push_state(compiler, CHAIN);
                    } 
    expression      { push_state(compiler, CHAIN); } 
    expression      { push_state(compiler, CHAIN); } 
    CLOSE_PAREN 
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
