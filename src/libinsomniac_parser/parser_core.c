#include <stdlib.h>
#include <string.h>

#include "parser_internal.h"

#include "scheme.h"
#include "lexer.h"

void push_parse_state(parser_core_type *parser, FILE *fin) {
    
    scanner_stack_type *scanner=alloc_scanner(parser);

    yylex_init_extra(parser, &(scanner->scanner));
    yyset_in(fin, scanner->scanner);

    scanner->previous=parser->scanner;
    parser->scanner=scanner;
}

void pop_parse_state(parser_core_type *parser) {

    scanner_stack_type *previous=0;

    yylex_destroy(peek_scanner(parser));

    previous=peek_previous(parser);

    free(parser->scanner);

    parser->scanner=previous;
}


/* Parse a file */
object_type *parse(parser_core_type *parser, FILE *in) {
    /* reset(interp);*/
    
    yyset_in(in, peek_scanner(parser));
    
    if(parse_internal(parser, peek_scanner(parser))) {
	return 0;
    }

    TRACE("\n")
    
    return parser->added;
}

/* Put the passed in object into the added buffer */
void add_object(parser_core_type *parser, object_type *obj) {
    parser->added=obj;
}

/* Create a character constant object */
void add_char(parser_core_type *parser, char *str) {
    object_type *obj=0;
    char c=*str;
    
    if(strcmp(str, "newline")==0) {
	c='\n';

    } else if(strcmp(str, "space")==0) {
	c=' ';

    } else if(*str=='x') { /* Hex encoded charater */
	uint64_t val=strtoul(str+1, 0, 16);
	c=0xff & val;
    }
    
    /* TODO: Possible GC snafu here, looks safe right now */
    obj=gc_alloc_object_type(parser->gc, CHAR);
    obj->value.char_val=c;
    add_object(parser, obj);
}

/* Create a number */
void add_number(parser_core_type *parser, char *str) {
    object_type *obj=0;

    obj=gc_alloc_object_type(parser->gc, FIXNUM);
    obj->value.int_val=strtoll(str, 0, 10);
    
    add_object(parser, obj);
}

/* Create an instance of a floating point number */
void add_float(parser_core_type *parser, char *str) {
    object_type *obj=0;
    char *c=str;
    
    /* check for / */
    while(*c!=0 && *c!='/') {
	c++;
    }

    /* TODO: Possible GC snafu */
   
    obj=gc_alloc_object_type(parser->gc, FLOATNUM);

    /* if we found a / then do the division 
       otherwise we convert it as any other real */
    if(*c=='/') {
	long double x,y;
	x=strtold(str,0);
	c++;
	y=strtold(c,0);
	
	/* check for div by 0 */
	if(y==0.0) {
	    parser->error=1;
	    obj->value.float_val=0;
	} else {
	    obj->value.float_val=x/y;
	}
	
    } else {
	obj->value.float_val=strtold(str, 0);
    }

    add_object(parser, obj);
}

void add_string(parser_core_type *interp, char *str) {}
void add_quote(parser_core_type *interp) {}
void add_vector(parser_core_type *interp) {}
void add_empty_vector(parser_core_type *interp) {}
void add_symbol(parser_core_type *interp, char *str) {}

void chain_state(parser_core_type *interp) {}
void push_state(parser_core_type *interp) {}
void pop_state(parser_core_type *interp) {}

void end_of_file(parser_core_type *interp) {}

void set(parser_core_type *interp, setting_type_enum setting) {}

