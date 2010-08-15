#include <stdio.h>

#include <util.h>
#include <ast.h>


/* A simple REPL */
void repl() {

    char buf[2048];
    
    while(1) {
	printf(">");
	scanf("%s",buf);
	
	/* echo the input */
	TRACE(buf);
    }

}

int main(int argc, char**argv) {
    printf("Insomniac Scheme\n");
    
    parser_core_type *parser=create_parser();
    
    repl();

    cleanup_parser(parser);

    return 0;
}
