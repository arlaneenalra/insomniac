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

%%

{SIGNS}?"0x"?{DIGITS}        { return NUM_TOKEN; }
"#t"                    { return TRUE_TOKEN; }
"#f"                    { return FALSE_TOKEN;} 

"out"                   { return OUT_TOKEN; }
"nop"                   { return NOP_TOKEN; }
"dup"                   { return DUP_TOKEN; }
"swap"                  { return SWAP_TOKEN; }
"cons"                  { return CONS_TOKEN; }
"sym"                   { return SYM_TOKEN; }

                       

"jnf"                   { return JNF_TOKEN; }
"jmp"                   { return JMP_TOKEN; }                       
                    
{IDENT}+':'             { return LABEL_TOKEN; }

<<EOF>>                 { return END_OF_FILE; }
%%

char * get_text(void * scanner) {
	return yyget_text(scanner);
}
