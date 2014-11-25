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

//%define api.value.type { buffer_type * }
%define api.value.type { ast_expression_type * }

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
%token PRIM_LAMBDA
%token PRIM_IF
%token PRIM_SET

%token PRIM_INCLUDE
%token SPEC_DEFINE

%token PRIM_DEFINE
%token PRIM_DEFINE_DYNAMIC
%token PRIM_ASM

%token END_OF_FILE

%%

top_level:
  begin_body  { }
  END_OF_FILE { YYACCEPT; }

self_evaluating:
    boolean
  | CHAR_CONSTANT                 {  }
  | string 
  | number

/* Matches all symbols
   We have to list all of the special case symbols here too
   or the compiler won't know how to handle them when it sees
   them out of context. */
symbol:
    AST_SYMBOL                    {  }


  
literal:
    quoted
  | self_evaluating 

expression:
    literal
  | procedure_call
  | symbol                        { } 

datum:
      literal
    | symbol                           
    | list
//    | procedure_call
   
list_end:
    list_next CLOSE_PAREN              { }
 
  | list_next DOT datum CLOSE_PAREN    { }
  | CLOSE_PAREN                        { }

list:
    OPEN_PAREN list_end                { }

list_next:
    datum                              { } 
  | datum list_next                    { }

quoted:
    QUOTE datum                             {  }
  | OPEN_PAREN PRIM_QUOTE datum CLOSE_PAREN {  }

    
boolean:
    TRUE_OBJ                      {  }
  | FALSE_OBJ                     {  }

number:
    FIXED_NUMBER                  {  }
  | FLOAT_NUMBER

string_body:
    STRING_CONSTANT              { }

string:
    DOUBLE_QUOTE string_body DOUBLE_QUOTE  { }
  | DOUBLE_QUOTE DOUBLE_QUOTE     {  } 
  
/* Some basic math procedures */
procedure_call:
    OPEN_PAREN primitive_procedures  {  }

primitive_procedures:
    math_calls
  | display
  | begin
  | define
  | if
  | lambda
  | set
  | user_call
  | include
  | asm

asm:
    PRIM_ASM asm_end CLOSE_PAREN    {  }

asm_end:
    raw_asm                         {  }
  | raw_asm asm_end                 { }

raw_asm:
    asm_types                  { }
  | self_evaluating
  | OPEN_PAREN CLOSE_PAREN     { }
  | OPEN_PAREN expression CLOSE_PAREN { }

asm_types:
    AST_SYMBOL
  | PRIM_DISPLAY
  | PRIM_BEGIN
  | PRIM_QUOTE
  | PRIM_LAMBDA
  | PRIM_IF
  | PRIM_SET
  | PRIM_DEFINE
  | PRIM_DEFINE_DYNAMIC
  | PRIM_ASM
  | MATH_OPS

include:
  PRIM_INCLUDE DOUBLE_QUOTE
  string_body DOUBLE_QUOTE
  CLOSE_PAREN                { }

if:
    PRIM_IF expression expression
    expression CLOSE_PAREN              { }

display:
    PRIM_DISPLAY expression CLOSE_PAREN { }

define:
    define_variable
  | define_dynamic

/* the most basic version of define */
define_variable:
  PRIM_DEFINE symbol expression CLOSE_PAREN  { }

define_dynamic:
  PRIM_DEFINE_DYNAMIC expression expression CLOSE_PAREN  { }

/* Set the value of a location */
set:
  PRIM_SET symbol expression CLOSE_PAREN     { } 

begin:
    PRIM_BEGIN begin_end   {  }

begin_body:
    expression             
  | expression begin_body  { } 

begin_end:
    CLOSE_PAREN
  | begin_body CLOSE_PAREN

/* Inline mathematical calls */
math_calls:
    math_call_op
    expression expression CLOSE_PAREN { }

math_call_op:
    MATH_OPS                          { }

/* call a user function */
user_call:
    expression user_call_end    { }

user_call_end:
    CLOSE_PAREN                 { }
  | user_call_body CLOSE_PAREN  { }

user_call_body:
    expression                  { }
  | expression user_call_body   { }  

/* A basic lambda expression */
lambda:
    PRIM_LAMBDA
    lambda_formals
    begin_end                   { }

lambda_formals:
    symbol                      { }
  | lambda_formals_list

lambda_formals_list:
    OPEN_PAREN CLOSE_PAREN      {  } // ignore arguments}
  | OPEN_PAREN lambda_formals_list_end   {  }

lambda_formals_list_end:
    symbol CLOSE_PAREN          { }
  | symbol lambda_formals_list_end { }
  | symbol DOT symbol CLOSE_PAREN  { }

%%

void parse_error(compiler_core_type *compiler, void *scanner, char *s) {
    (void)fprintf(stderr,"There was an error parsing '%s' on line %i\n", 
                  s, yyget_lineno(scanner) + 1);
}


int parse_internal(compiler_core_type *compiler, void *scanner) {
    int ret_val = 0;
    
    ret_val = yyparse(compiler, scanner);


    return ret_val;
}


