%option noyywrap reentrant
%option always-interactive
%option yylineno
%option nounput noinput

%{

#include "asm_internal.h"

%}

DIGITS    [0-9]+
EOL       \n|\r\n|\n\r|\r
WS	  {EOL}|[[:blank:]]
IDENT     [!$%&*+\-./<=>?@^_~[:alnum:]]
SIGNS     [-+]
LABEL     {IDENT}+

CHAR_VAL  (newline|space|[^{WS}])

%x EXPECT_CHAR
%x EXPECT_STRING
%x EXPECT_TARGET
%x EXPECT_LABEL

%%
";".*$                  { /* Comment */ }

{SIGNS}?{DIGITS}        { return OP_LIT_FIXNUM; }
"#t"                    { return OP_LIT_TRUE; }
"#f"                    { return OP_LIT_FALSE;} 
"()"                    { return OP_LIT_EMPTY; }

"out"                   { return OP_OUTPUT; }
"read"                  { return OP_GETC; }

"nop"                   { return OP_NOP; }
"dup"                   { return OP_DUP_REF; }
"depth"                 { return OP_DEPTH; }
"drop"                  { return OP_DROP; }
"swap"                  { return OP_SWAP; }
"sym"                   { return OP_MAKE_SYMBOL; }

"cons"                  { return OP_CONS; }
"car"                   { return OP_CAR; }
"cdr"                   { return OP_CDR; }
"set-car"               { return OP_SET_CAR; }
"set-cdr"               { return OP_SET_CDR; }

"bind"                  { return OP_BIND; }
"!"                     { return OP_SET; }
"@"                     { return OP_READ; }


"+"                     { return OP_ADD; }
"-"                     { return OP_SUB; }
"*"                     { return OP_MUL; }
"/"                     { return OP_DIV; }
"%"                     { return OP_MOD; }

"="                     { return OP_NUMERIC_EQUAL; }
"<"                     { return OP_NUMERIC_LT; }
">"                     { return OP_NUMERIC_GT;}

"eq"                    { return OP_EQ; }
"not"                   { return OP_NOT; }
                       
"jnf"                   { BEGIN(EXPECT_TARGET);
                          return OP_JNF; }
"jmp"                   { BEGIN(EXPECT_TARGET);
                          return OP_JMP; }

<EXPECT_TARGET>{LABEL}  { BEGIN(INITIAL);
                          return LABEL_TOKEN; }

{LABEL}/":"             { BEGIN(EXPECT_LABEL);
                          return LABEL_TOKEN; }
<EXPECT_LABEL>":"       {/* Ignore end of label marker */
                          BEGIN(INITIAL); }

"#\\"                     { BEGIN(EXPECT_CHAR); }

<EXPECT_CHAR>{
    "x"[[:xdigit:]]+     { BEGIN(INITIAL);
			  return OP_LIT_CHAR; }

    {CHAR_VAL}          { BEGIN(INITIAL);
			  return OP_LIT_CHAR; }

}

\"                      { BEGIN(EXPECT_STRING);
                          return STRING_START_TOKEN; }

<EXPECT_STRING>{

	([^\"]|\\\")*     { return OP_LIT_STRING; }
        \"                { BEGIN(INITIAL); 
                            return STRING_END_TOKEN; }
}

{WS}                    { /* Ignore white space */ }


<<EOF>>                 { return END_OF_FILE; }


%%

char * get_text(void * scanner) {
	return yyget_text(scanner);
}
