%option noyywrap reentrant bison-bridge
%option always-interactive
%option yylineno
%option nounput noinput
%option extra-type="compiler_core_type *"

%{
#include "bootstrap_internal.h"
#include "scheme.h"

/* avoid a compiler warning */
#define ECHO /* do nothing */

%}

DIGITS    [0-9]+
EOL       \n|\r\n|\n\r|\r
WS	  {EOL}|[[:blank:]]
IDENT     [-!$%&*+\./:<=>?@^_~[:alnum:]]
SIGNS     [-+]
MATH      [-+*/%><=]

CHAR_VAL      (newline|space|[^{WS}]|x[0-9A-F]+)

%x EXPECT_CHAR
%x EXPECT_STRING

%%
"("|"["   { return OPEN_PAREN; }
")"|"]"   { return CLOSE_PAREN; }
"#("      { return START_VECTOR; }
"."       { return DOT; }
"'"       { return QUOTE; }

"#t"      { return TRUE_OBJ; }
"#f"      { return FALSE_OBJ; }

{WS}*     /* Do nothing with white space */

{MATH}    { return MATH_OPS; }

"begin"   { return PRIM_BEGIN;  }
"quote"   { return PRIM_QUOTE; }
"define"  { return PRIM_DEFINE; }
"lambda"  { return PRIM_LAMBDA; }
"if"      { return PRIM_IF; }
"set!"    { return PRIM_SET; }

"include" { return PRIM_INCLUDE; }
"asm"     { return PRIM_ASM; }

{SIGNS}?{DIGITS}                       { return FIXED_NUMBER; }
{SIGNS}?({DIGITS}|nan|inf)?"."{DIGITS} { return FLOAT_NUMBER; }
{SIGNS}?{DIGITS}[/]{DIGITS}              { return FLOAT_NUMBER; }


#\\       { BEGIN(EXPECT_CHAR); }

<EXPECT_CHAR>{CHAR_VAL} {	BEGIN(INITIAL); 
				return CHAR_CONSTANT; }

\"        { BEGIN(EXPECT_STRING); return DOUBLE_QUOTE;}

<EXPECT_STRING>{

	([^\"]|\\\")*  { return STRING_CONSTANT; }
	\"             { BEGIN(INITIAL); return DOUBLE_QUOTE; }
}


{IDENT}+  { return AST_SYMBOL; }

[;].*     /* Eat comments */
#!r6rs    /* Treat this as a comment */      

<<EOF>>   {
            yypop_buffer_state(yyscanner);

            yyget_extra(yyscanner)->include_depth--;

            if( !YY_CURRENT_BUFFER) {
              return END_OF_FILE;
            }

          }
%%

char * get_text(void * scanner) {
	return yyget_text(scanner);
}

/* Push the current lexer state on the stack and replace it with the included
   file. */
void parse_push_state(compiler_core_type *compiler, FILE *file) {
    yypush_buffer_state(
      yy_create_buffer(file, YY_BUF_SIZE, compiler->scanner), compiler->scanner);

}


