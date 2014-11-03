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

%define api.value.type { buffer_type * }

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
%token PRIM_IF

%token SPEC_DEFINE

%token END_OF_FILE

%%

top_level:
  begin_body  { buffer_append(compiler->buf, $1, -1); }
  END_OF_FILE { YYACCEPT; }

self_evaluating:
    boolean
  | CHAR_CONSTANT                       { EMIT_NEW($$, char, yyget_text(scanner)); }
  | string 
  | number

/* Matches all symbols
   We have to list all of the special case symbols here too
   or the compiler won't know how to handle them when it sees
   them out of context. */
symbol:
  symbol_types                         { EMIT_NEW($$, symbol, yyget_text(scanner)); }

symbol_types:
    AST_SYMBOL
  | PRIM_DISPLAY
  | PRIM_BEGIN
  | PRIM_QUOTE
  | PRIM_DEFINE
  | MATH_OPS
  
literal:
    quoted
  | self_evaluating 

expression:
    literal
  | procedure_call
  | symbol                             {
                                         $$ = $1; 
                                         EMIT($$, op, "@");
                                       }

datum:
      literal
    | symbol                           
    | list
    | procedure_call
   
list_end:
    list_next CLOSE_PAREN
  | list_next DOT datum CLOSE_PAREN
  | CLOSE_PAREN

list:
    OPEN_PAREN list_end                { $$ = $2; }

list_next:
    datum                               
  | datum list_next                    {
                                         $$ = $1; 
                                         buffer_append($$, $2, -1); 
                                       }

quoted:
    QUOTE datum                             { $$ = $2; }
  | OPEN_PAREN PRIM_QUOTE datum CLOSE_PAREN { $$ = $3; }

    
boolean:
    TRUE_OBJ                      { EMIT_NEW($$, boolean, 1); }
  | FALSE_OBJ                     { EMIT_NEW($$, boolean, 0); }

number:
    FIXED_NUMBER                  { EMIT_NEW($$, fixnum, yyget_text(scanner)); }
  | FLOAT_NUMBER

string_end:
    STRING_CONSTANT DOUBLE_QUOTE
  | DOUBLE_QUOTE

string:
    DOUBLE_QUOTE string_end
  
/* Some basic math procedures */
procedure_call:
    OPEN_PAREN primitive_procedures  { $$ = $2; }

primitive_procedures:
    math_calls
  | display
  | begin
  | define
  | if

if:
  PRIM_IF expression expression expression CLOSE_PAREN {
                                                         $$ = $2;
                                                         emit_if(compiler, $2, $3, $4);
                                                       }

display:
    PRIM_DISPLAY expression CLOSE_PAREN {
                                          $$ = $2;
                                          EMIT($$, op, "out ()");
                                        }

define:
  define_variable

/* the most basic version of define */
define_variable:
  PRIM_DEFINE symbol expression CLOSE_PAREN  {
                                               $$ = $3; 
                                               buffer_append($$, $2, -1);
                                               EMIT($$, op, "bind ()");
                                             }

begin:
    PRIM_BEGIN begin_end   { $$ = $2; }

begin_body:
    expression             
  | expression begin_body  { 
                              $$ = $1;
                              EMIT($$, op, "drop");
                              buffer_append($$, $2, -1);
                           } 

begin_end:
    CLOSE_PAREN
  | begin_body CLOSE_PAREN

/* Inline mathematical calls */
math_calls:
    math_call_op                          
    expression expression CLOSE_PAREN {
                                         $$ = $2;
                                         buffer_append($$, $3, -1);
                                         buffer_append($$, $1, -1);
                                      }

math_call_op:
    MATH_OPS                          { EMIT_NEW($$, op, yyget_text(scanner)); }
%%

void yyerror(compiler_core_type *compiler, void *scanner, char *s) {
    (void)fprintf(stderr,"There was an error parsing %s on line %i\n", 
                  s, yyget_lineno(scanner));
}


int parse_internal(compiler_core_type *compiler, void *scanner) {
    int ret_val = 0;
    
    ret_val = yyparse(compiler, scanner);


    return ret_val;
}
