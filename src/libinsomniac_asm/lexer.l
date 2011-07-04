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

CHAR_VAL  (newline|space|[^{WS}]|x[0-9A-F]+)

%x EXPECT_CHAR
%x EXPECT_STRING

%%

{SIGNS}?"0x"?{DIGITS}        { return OP_LIT_FIXNUM; }
"#t"                    { return OP_LIT_TRUE; }
"#f"                    { return OP_LIT_FALSE;} 
"()"                    { return OP_LIT_EMPTY; }

"out"                   { return OP_OUTPUT; }
"nop"                   { return OP_NOP; }
"dup"                   { return OP_DUP_REF; }
"swap"                  { return OP_SWAP; }
"cons"                  { return OP_CONS; }
"sym"                   { return OP_MAKE_SYMBOL; }

                       

"jnf"                   { return OP_JNF; }
"jmp"                   { return OP_JMP; }

#\\                     { BEGIN(EXPECT_CHAR); }

<EXPECT_CHAR>{CHAR_VAL} { BEGIN(INITIAL);
			  return OP_LIT_CHAR; }

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
