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
%token PRIM_LAMBDA
%token PRIM_IF
%token PRIM_SET

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

    /* for now, it's not directly possible to redefine these */
//  | PRIM_DISPLAY
//  | PRIM_BEGIN
//  | PRIM_QUOTE
//  | PRIM_DEFINE
//  | PRIM_LAMBDA
//  | MATH_OPS
//  | PRIM_IF
//  | PRIM_SET
  
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
//    | procedure_call
   
list_end:
    list_next CLOSE_PAREN              {
                                         EMIT_NEW($$, op, "()");
                                         buffer_append($$, $1, -1);
                                       }
 
  | list_next DOT datum CLOSE_PAREN    {
                                         NEW_BUF($$);
                                         buffer_append($$, $3, -1);
                                         buffer_append($$, $1, -1);
                                       }
  | CLOSE_PAREN                        { EMIT_NEW($$, op, "()"); }

list:
    OPEN_PAREN list_end                { $$ = $2; }

list_next:
    datum                              { EMIT($$, op, "cons"); } 
  | datum list_next                    {
                                         $$ = $2; 
                                         buffer_append($$, $1, -1); 
                                         EMIT($$, op, "cons");
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
    STRING_CONSTANT               { EMIT_NEW($$, string, yyget_text(scanner)); }


string:
    DOUBLE_QUOTE string_end DOUBLE_QUOTE      { $$ = $2; }
  | DOUBLE_QUOTE DOUBLE_QUOTE     { EMIT_NEW($$, string, ""); } 
  
/* Some basic math procedures */
procedure_call:
    OPEN_PAREN primitive_procedures  { $$ = $2; }

primitive_procedures:
    math_calls
  | display
  | begin
  | define
  | if
  | lambda
  | set
  | user_call

if:
    PRIM_IF expression expression
    expression CLOSE_PAREN              {
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

/* Set the value of a location */
set:
  PRIM_SET symbol expression CLOSE_PAREN     {
                                               $$ = $3; 
                                               buffer_append($$, $2, -1);
                                               EMIT($$, op, "! ()");
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

/* call a user function */
user_call:
    expression user_call_end    {
                                  $$ = $2; /* Setup call */
                                  buffer_append($$, $1, -1); /* get procedure */
                                  EMIT($$, op, "call_in");
                                }

user_call_end:
    CLOSE_PAREN                 { EMIT_NEW($$, op, "()"); }
  | user_call_body CLOSE_PAREN  {
                                  EMIT_NEW($$, op, "()");
                                  buffer_append($$, $1, -1);
                                }

user_call_body:
    expression                  { EMIT($$, op, "cons"); }
  | expression user_call_body   { 
                                  $$ = $2;
                                  buffer_append($$, $1, -1);
                                  EMIT($$, op, "cons");
                                }  

/* A basic lambda expression */
lambda:
    PRIM_LAMBDA
    lambda_formals
    begin_end                   {
                                  NEW_BUF($$);
                                  emit_lambda(compiler, $$, $2, $3);
                                }

lambda_formals:
    symbol                      { EMIT($$, op, "bind"); }
  | lambda_formals_list

lambda_formals_list:
    OPEN_PAREN CLOSE_PAREN      { EMIT_NEW($$, op, "drop"); } // ignore arguments}
  | OPEN_PAREN lambda_formals_list_end   { $$ = $2; }

lambda_formals_list_end:
    symbol CLOSE_PAREN          {
                                  // single binding
                                  EMIT_NEW($$, op, "car");
                                  buffer_append($$, $1, -1); // symbol
                                  EMIT($$, op, "bind");
                                }
  | symbol lambda_formals_list_end {
                                     EMIT_NEW($$, op, "dup car");
                                     buffer_append($$, $1, -1);
                                     EMIT($$, op, "bind cdr");
                                     buffer_append($$, $2, -1);

                                   }
  | symbol DOT symbol CLOSE_PAREN  {
                                     // single binding
                                     EMIT_NEW($$, op, "dup car");
                                     buffer_append($$, $1, -1); // symbol
                                     EMIT($$, op, "bind");
                                     EMIT($$, op, "cdr");
                                     buffer_append($$, $3, -1); // symbol
                                     EMIT($$, op, "bind");
                                   }

%%

void yyerror(compiler_core_type *compiler, void *scanner, char *s) {
    (void)fprintf(stderr,"There was an error parsing %s on line %i\n", 
                  s, yyget_lineno(scanner) + 1);
}


int parse_internal(compiler_core_type *compiler, void *scanner) {
    int ret_val = 0;
    
    ret_val = yyparse(compiler, scanner);


    return ret_val;
}
