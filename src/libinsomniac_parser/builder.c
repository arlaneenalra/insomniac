/*
  Code to build an instance of our AST
 */

#include <stdlib.h>
#include <string.h>
#include "parser_internal.h"


/* Setup an instance of our parser and allocate all global 
   objects */
parser_core_type *create_parser() {
    parser_core_type *parser=0;
    
    parser=(parser_core_type *)malloc(sizeof(parser_core_type));
    
    if(parser) {
	bzero(parser, sizeof(parser_core_type));
    }
    
    return parser;
}


void cleanup_parser(parser_core_type *parser) {
    
    if(parser) {
	free(parser);
    }

}
