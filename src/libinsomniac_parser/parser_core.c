#include <stdlib.h>
#include <string.h>

#include "parser_internal.h"

#include "scheme.h"
#include "lexer.h"

/* Create a new tuple object with a
   given car and cdr */
object_type *cons(parser_core_type *parser, object_type *car,
		  object_type *cdr) {
    object_type *tuple=0;
    
    gc_protect(parser->gc);

    tuple=gc_alloc_object_type(parser->gc, TUPLE);
    car(tuple)=car;
    cdr(tuple)=cdr;
    
    gc_unprotect(parser->gc);

    return tuple;
}

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
    

    gc_protect(parser->gc);

    obj=gc_alloc_object_type(parser->gc, CHAR);
    obj->value.char_val=c;
    add_object(parser, obj);
    
    gc_unprotect(parser->gc);
}

/* Create a number */
void add_number(parser_core_type *parser, char *str) {
    object_type *obj=0;

    gc_protect(parser->gc);

    obj=gc_alloc_object_type(parser->gc, FIXNUM);
    obj->value.int_val=strtoll(str, 0, 10);
    
    add_object(parser, obj);

    gc_unprotect(parser->gc);
}

/* Create an instance of a floating point number */
void add_float(parser_core_type *parser, char *str) {
    object_type *obj=0;
    char *c=str;
    
    /* check for / */
    while(*c!=0 && *c!='/') {
	c++;
    }

    gc_protect(parser->gc);

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
    
    gc_unprotect(parser->gc);
}

void add_quote(parser_core_type *interp) {}

void add_string(parser_core_type *interp, char *str) {}
void add_vector(parser_core_type *interp) {}
void add_empty_vector(parser_core_type *interp) {}
void add_symbol(parser_core_type *interp, char *str) {}

/* Save the current list off so that we can get back to it */
void push_state(parser_core_type *parser) {
    /*object_type *new_state=alloc_object(interp, TUPLE); */

    TRACE("Pu");

    gc_protect(parser->gc);

    /* push the current state onto the state stack */
    parser->state_stack=cons(parser, parser->current, parser->state_stack);
    
    parser->current=gc_alloc_object_type(parser->gc, TUPLE);
    cdr(parser->current)=parser->empty_list;

    gc_unprotect(parser->gc);
}

/* Add a new state to the current chain of states without
   pushing it onto the state stack */
void chain_state(parser_core_type *parser) {
    
    TRACE("C")

    /* handle the first list entry correctly */
      if(car(parser->current)==0) {
	/* we don't need to do anythin else here */
	set(parser, CAR);
	return;
    } 

    /* Before throwing current, we 
       need to make sure that it has been added */

    push_state(parser);
    parser->state_stack->type=CHAIN;
    
    set(parser, CAR);
}

/* Pop a previously saved list */
void pop_state(parser_core_type *parser) {
    object_type *state=0;

    TRACE("Po")
    
    if(parser->state_stack==0) {
	fail("Attempt to pop non-existent state");
    }

    state=parser->state_stack;
    
    parser->added=parser->current;
    parser->current=car(state);
    parser->state_stack=cdr(state);

    /* we are in the depths of a chain, pop until 
       we're out of it */
    if(state->type==CHAIN) {
	set(parser, CDR);
	pop_state(parser);
    }
}


void end_of_file(parser_core_type *interp) {}

/* Attach an added object to our graph of objects */
void set(parser_core_type *parser, setting_type_enum setting) {
    object_type *current=0;
    object_type *obj=0;
    
    
    obj=parser->added;
    current=parser->current;

    if(current !=0 && current->type!=TUPLE) {
	fail("Attempting to set on none tuple.");
    }

    switch(setting) {
    case CAR:
	TRACE("Sa");
	if(current==0) {
	    fail("Attempt to set car on null pointer");
	}

	car(current)=obj;
	break;

    case CDR:
	TRACE("Sd");
	if(current==0) {
	    fail("Attempt to set cdr on null pointer");
	}

	cdr(current)=obj;
	break;

    default:
	fail("Invalide setting state!");
    }
}

