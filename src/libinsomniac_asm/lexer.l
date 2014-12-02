%option noyywrap reentrant
%option always-interactive
%option yylineno
%option nounput noinput
%option debug

%{

#include "asm_internal.h"
#define ECHO { for(int i=0; i< yyleng; i++) {fprintf(yyout, "Unmatched on line:%d '%c' %d\n", yylineno, yytext[0], yytext[0]); } }


%}

DIGITS    [0-9]+

WS	  [\n\r[:blank:]]
IDENT     [!$%&*+\-./<=>?@^_~[:alnum:]]
SIGNS     [-+]
LABEL     {IDENT}+

CHAR_VAL  (newline|space|eof|[^{WS}])

%x EXPECT_CHAR
%x EXPECT_STRING
%x EXPECT_TARGET
%x EXPECT_LABEL

%%

{WS}                    { /* Ignore white space */ }

";".*$                  { /* Comment */ }

{SIGNS}?{DIGITS}        { return OP_LIT_FIXNUM; }
"#t"                    { return OP_LIT_TRUE; }
"#f"                    { return OP_LIT_FALSE;} 
"()"                    { return OP_LIT_EMPTY; }

"fixnum?"               { return OP_IS_FIXNUM; }
"bool?"                 { return OP_IS_BOOL; }
"char?"                 { return OP_IS_CHAR; }
"string?"               { return OP_IS_STRING; }
"symbol?"               { return OP_IS_SYMBOL; }
"vector?"               { return OP_IS_VECTOR; }
"pair?"                 { return OP_IS_PAIR; }
"null?"                 { return OP_IS_EMPTY; }
"proc?"                 { return OP_IS_CLOSURE; }
"self?"                 { return OP_IS_SELF; }

"vector"                { return OP_MAKE_VECTOR; }
"vec@"                  { return OP_VECTOR_REF; }
"vec!"                  { return OP_VECTOR_SET; }

"out"                   { return OP_OUTPUT; }
"read"                  { return OP_GETC; }
"slurp"                 { return OP_SLURP; }
"asm"                   { return OP_ASM; }
"import"                { return OP_IMPORT; }

"nop"                   { return OP_NOP; }
"dup"                   { return OP_DUP_REF; }
"depth"                 { return OP_DEPTH; }
"drop"                  { return OP_DROP; }
"swap"                  { return OP_SWAP; }
"rot"                   { return OP_ROT; }
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

"restore"               { return OP_RESTORE; }

"adopt"                 { return OP_ADOPT; }
"proc"                  { BEGIN(EXPECT_TARGET);
                          return OP_PROC; }
"call"                  { BEGIN(EXPECT_TARGET);
                          return OP_CALL; }
"continue"              { BEGIN(EXPECT_TARGET);
                          return OP_CONTINUE; }
"jnf"                   { BEGIN(EXPECT_TARGET);
                          return OP_JNF; }
"jmp"                   { BEGIN(EXPECT_TARGET);
                          return OP_JMP; }

"gc-stats"              { return OP_GC_STATS; }

<EXPECT_TARGET>{

     {LABEL}            { BEGIN(INITIAL);
                          return LABEL_TOKEN; }
     {WS}               { /*Ignore whitespace */ }
}

"jin"                   { return OP_JIN; }
"ret"                   { return OP_RET; }
"call_in"               { return OP_CALL_IN; }
"tail_call_in"          { return OP_TAIL_CALL_IN; }
"call_ext"              { return OP_CALL_EXT; }


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

[sS]\"                    { BEGIN(EXPECT_STRING);
                          return SYMBOL_START_TOKEN; }
\
\"                      { BEGIN(EXPECT_STRING);
                          return STRING_START_TOKEN; }

<EXPECT_STRING>{

	([^\"]|\\\")*     { return OP_LIT_STRING; }
        \"                { BEGIN(INITIAL); 
                            return STRING_END_TOKEN; }
}


<<EOF>>                 { return END_OF_FILE; }


%%

char * get_text(void * scanner) {
	return yyget_text(scanner);
}

