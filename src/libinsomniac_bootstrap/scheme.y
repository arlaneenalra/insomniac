%pure-parser 
/* %define api.pure */

%{
#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#define yyerror parse_error
%}

%parse-param {compiler_core_type *compiler}
%parse-param {void *scanner} 
%lex-param {void *scanner} 

%define api.value.type { ins_stream_type * }

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

%token PRIM_BEGIN
%token PRIM_QUOTE
%token PRIM_LAMBDA
%token PRIM_SET

%token PRIM_IF
%token PRIM_COND

%token PRIM_AND
%token PRIM_OR

%token PRIM_INCLUDE
%token SPEC_DEFINE

%token PRIM_DEFINE
%token PRIM_ASM

%token END_OF_FILE

%%

top_level:
  begin_body                      { stream_concat(compiler->stream, $1); }  
  END_OF_FILE                     { YYACCEPT; }

self_evaluating:
    boolean
  | CHAR_CONSTANT                 { STREAM_NEW($$, char, yyget_text(scanner)); }
  | string 
  | number

/* Matches all symbols
   We have to list all of the special case symbols here too
   or the compiler won't know how to handle them when it sees
   them out of context. */

symbol:
    AST_SYMBOL                    { STREAM_NEW($$, symbol, yyget_text(scanner)); }


  
literal:
    quoted                        { STREAM_NEW($$, quoted, $1); } 
  | self_evaluating 

expression:
    literal
  | procedure_call
  | symbol                        { STREAM_NEW($$, load, $1); } 

datum:
      literal
    | symbol
    | list
//    | procedure_call
   
list_end:
    list_next CLOSE_PAREN              {
                                         STREAM_NEW($$, literal, "()");
                                         stream_concat($$, $1);
                                       }
 
  | list_next DOT datum CLOSE_PAREN    {
                                         $$ = $3;
                                         stream_concat($$, $1);
                                       }
  | CLOSE_PAREN                        { STREAM_NEW($$, literal, "()"); }

list:
    OPEN_PAREN list_end                { STREAM_NEW($$, quoted, $2); }

list_next:
    datum                                 
  | datum list_next                    {
                                         $$ = $2;
                                         stream_concat($$, $1);
                                       }

quoted:
    QUOTE datum                             { $$ = $2; }
  | OPEN_PAREN PRIM_QUOTE datum CLOSE_PAREN { $$ = $3; }

    
boolean:
    TRUE_OBJ                      { STREAM_NEW($$, boolean, 1); }
  | FALSE_OBJ                     { STREAM_NEW($$, boolean, 0); }

number:                           
    FIXED_NUMBER                { STREAM_NEW($$, literal, yyget_text(scanner)); }
  | FLOAT_NUMBER                { STREAM_NEW($$, literal, yyget_text(scanner)); } 

string_body:
    STRING_CONSTANT               { STREAM_NEW($$, string, yyget_text(scanner)); }

string:
    DOUBLE_QUOTE string_body DOUBLE_QUOTE  { $$ = $2; }
  | DOUBLE_QUOTE DOUBLE_QUOTE     { STREAM_NEW($$, string, ""); }
  
/* Some basic math procedures */
procedure_call:
    OPEN_PAREN primitive_procedures  { $$ = $2; }

primitive_procedures:
    math_calls
  | begin
  | define
  | if
  | lambda
  | set
  | user_call
  | include
  | asm
  | cond
  | and
  | or

asm:
    PRIM_ASM asm_end CLOSE_PAREN    { STREAM_NEW($$, asm, $2); }

asm_end:
    raw_asm                         { $$ = $1; }
  | raw_asm asm_end                 {
                                      $$ = $1;
                                      stream_concat($$, $2);
                                    }

raw_asm:
    asm_types                  { STREAM_NEW($$, op, yyget_text(scanner)); }
  | self_evaluating
  | OPEN_PAREN CLOSE_PAREN     { STREAM_NEW($$, literal, "()"); }
  | OPEN_PAREN expression CLOSE_PAREN { STREAM_NEW($$, asm_stream, $2); }

asm_types:
    AST_SYMBOL
  | PRIM_BEGIN
  | PRIM_QUOTE
  | PRIM_LAMBDA
  | PRIM_IF
  | PRIM_SET
  | PRIM_DEFINE
  | PRIM_ASM
  | MATH_OPS
  | PRIM_COND
  | PRIM_AND
  | PRIM_OR

two_args:
    expression expression                  { STREAM_NEW($$, two_arg, $1, $2); }

include: /* Only single arg include and is effectively an empty node. */ 
    PRIM_INCLUDE DOUBLE_QUOTE
    string_body DOUBLE_QUOTE
    CLOSE_PAREN                {
                                 NEW_STREAM($$);
                                 setup_include(compiler, $3);
                               }

if:
    PRIM_IF expression if_end                  { STREAM_NEW($$, if, $2, $3); }

if_end:
    two_args CLOSE_PAREN                       { $$ = $1; }
  | expression CLOSE_PAREN                     { /* Handle (if arg true) */
                                                 STREAM_NEW($$, two_arg, $1, 0);
                                                 STREAM_NEW(($$->head->value.two.stream2),
                                                  literal, "()");
                                               }

and:
    PRIM_AND boolean_end                       { STREAM_NEW($$, and, $2); }

or:
    PRIM_OR boolean_end                        { STREAM_NEW($$, or, $2); }

boolean_body:
    expression 
  | expression boolean_body                    { $$ = $1; stream_concat($$, $2); }

boolean_end:
    CLOSE_PAREN
  | boolean_body CLOSE_PAREN

cond:
    PRIM_COND cond_clause_list                 { STREAM_NEW($$, cond, $2); }

cond_clause:
    OPEN_PAREN expression begin_end            { STREAM_NEW($$, two_arg, $2, $3); }

cond_clause_list_end:
    cond_clause                                { STREAM_NEW($$, cond, $1); }
  | cond_clause cond_clause_list_end           { STREAM_NEW($$, cond, $1);  stream_concat($$, $2); }

cond_clause_list:
    CLOSE_PAREN
  | cond_clause_list_end CLOSE_PAREN

define:
    define_variable
  | define_lambda


/* the most basic version of define */
define_variable:
    PRIM_DEFINE symbol expression CLOSE_PAREN  { STREAM_NEW($$, bind, $3, $2); }

define_lambda:
    PRIM_DEFINE OPEN_PAREN
    symbol define_lambda_body                  { STREAM_NEW($$, bind, $4, $3); }

define_lambda_body:
    lambda_formals_list 
    begin_end                                  { STREAM_NEW($$, lambda, $1, $2); }

/* Set the value of a location */
set:
    PRIM_SET symbol expression CLOSE_PAREN     { STREAM_NEW($$, store, $3, $2); } 

begin:
    PRIM_BEGIN begin_end   { $$ = $2; }

begin_body:
    expression              
  | expression begin_body  { $$ = $1; stream_concat($$, $2); }

begin_end:
    CLOSE_PAREN
  | begin_body CLOSE_PAREN

/* Inline mathematical calls */
math_calls:
    math_call_op two_args CLOSE_PAREN { STREAM_NEW($$, math, $1, $2); }

math_call_op:
    MATH_OPS                          { STREAM_NEW($$, op, yyget_text(scanner)); }

/* call a user function */
user_call:
    expression user_call_end    { STREAM_NEW($$, call, $1, $2); }

user_call_end:
    CLOSE_PAREN                 { NEW_STREAM($$); }
  | user_call_body CLOSE_PAREN  { $$ = $1; }

user_call_body:
    expression                  { $$ = $1; }
  | expression user_call_body   { $$ = $2; stream_concat($2, $1); }  

/* A basic lambda expression */
lambda:
    PRIM_LAMBDA
    lambda_formals
    begin_end                   { STREAM_NEW($$, lambda, $2, $3); }

lambda_formals:                 /* if formals ends in a () it's a fixed list
                                   otherwise the it's a variadic formals list */
    symbol
  | OPEN_PAREN lambda_formals_list { $$ = $2; }

lambda_formals_list:
    CLOSE_PAREN                    { NEW_STREAM($$); } /* ignore arguments */
  | lambda_formals_list_end        { $$ = $1; }

lambda_formals_list_end:
    symbol CLOSE_PAREN             {
                                     /* End of a list */
                                     $$ = $1; STREAM($$, literal, "()");
                                   }
  | symbol lambda_formals_list_end {
                                     /* Add an element in the middle of a list */
                                     $$ = $1; stream_concat($$, $2); 
                                   }
  | DOT symbol CLOSE_PAREN         {
                                     /* Last element takes rest */
                                     //stream_concat($$, $2);
                                     $$ = $2;
                                   }

%%

void parse_error(compiler_core_type *compiler, void *scanner, char *s) {
    if (compiler->include_depth >= 0) {
      (void)fprintf(stderr,"In file %s\n", compiler->include_stack[compiler->include_depth]);
    }
    (void)fprintf(stderr,"There was an error parsing '%s' on line %i near: '%s'\n", 
                  s, yyget_lineno(scanner) + 1, yyget_text(scanner));
}


int parse_internal(compiler_core_type *compiler, void *scanner) {
    int ret_val = 0;
    
    ret_val = yyparse(compiler, scanner);

    return ret_val;
}


