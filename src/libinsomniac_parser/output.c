#include <stdlib.h>
#include <stdio.h>

#include <util.h>
#include <object.h>
#include "parser_internal.h"

/* Is this object a tuple? */
bool is_tuple(parser_core_type *parser, object_type *obj) {
    return obj!=0 && obj->type==TUPLE;
}

/* Is the object a quoted list? */
bool is_quoted(parser_core_type *parser, object_type *obj) {
    
    return is_tuple(parser, obj)
	&& car(obj)==parser->quote;
}

/* Is this the empty list? */
bool is_empty_list(parser_core_type *parser, object_type *obj) {
    return obj==parser->empty_list;
}



/* Output an object graph  */
void output_stream(parser_core_type *parser, object_type *obj, FILE *fout) {
    /* static object_type *last_closure=0; */
    object_type *car=0;
    object_type *cdr=0;
    uint64_t i=0;


    /* make sure there is something to display */
    if(obj==parser->empty_list) {
	fprintf(fout,"()");
	return;
    }
    
    if(obj==0) {
	fprintf(fout,"nil");
	return;
    }
    
    switch(obj->type) {
    case FIXNUM:
	fprintf(fout,"%" PRIi64, obj->value.int_val);
	break;
	
    case FLOATNUM:
	fprintf(fout,"%Lg", obj->value.float_val);
	break;

    case BOOL:
	if(obj==true(parser)) {
	    fprintf(fout,"#t");
	} else if (obj==false(parser)) {
	    fprintf(fout,"#f");
	} else {
	    fail("BOOL is not a boolean");
	}
	break;

    case CHAR:
	fprintf(fout,"#\\");
	if(obj->value.char_val=='\n') {
	    fprintf(fout,"newline");
	} else if(obj->value.char_val==' ') {
	    fprintf(fout,"space");
	} else {
	    fprintf(fout,"%c", obj->value.char_val);
	}

	break;

    case STRING:
	fprintf(fout,"\"%s\"", obj->value.string_val);
	break;

    case TUPLE:
	car=car(obj);
	cdr=cdr(obj);
	
	/* TODO: This could probably be simplified */
	if(is_quoted(parser, obj)) {
	    fprintf(fout,"'");
	    if(cdr==0) {
		parser->error=1;
		return;
	    }
	    output_stream(parser, car(cdr), fout);

	} else {
	    fprintf(fout,"(");
	    output_stream(parser, car, fout);

	    if(!is_empty_list(parser, cdr)) {
		if(cdr->type==TUPLE) {

		    while(!is_empty_list(parser, cdr) && is_tuple(parser, cdr)) {
			fprintf(fout," ");

			car=car(cdr);
			cdr=cdr(cdr);

			output_stream(parser, car, fout);
		    
			/* if the next element is not the empty list
			   end with . cdr */
			if(!is_empty_list(parser, cdr) && !is_tuple(parser,cdr)) {
			    fprintf(fout," . ");
			    output_stream(parser, cdr, fout);
			}
		    
		    }

		} else {
		    fprintf(fout," . ");
		    output_stream(parser, cdr, fout);
		}
	    }

	    fprintf(fout,")");

	}
	
	break;
    case SYM:
	fprintf(fout,"%s", obj->value.string_val);
	break;

    /* case PRIM: */
    /* 	fprintf(fout,"#<primitive procedure:@%p>", (void *)obj); */
    /* 	break; */
    /* case PORT: */
    /* 	fprintf(fout,"#<port:@%p in:%i out:%i>", (void *)obj->value.port_val.port, */
    /* 	       obj->value.port_val.input, obj->value.port_val.output); */
    /* 	break; */
    /* case CLOSURE: */

    /* 	/\* avoid infinite recursion *\/ */
    /* 	if(last_closure==obj) { */
    /* 	    fprintf(fout,"#<closure:current>"); */
    /* 	    return; */
    /* 	} */

    /* 	last_closure=obj; */

    /* 	fprintf(fout,"#<closure: params:"); */
    /* 	output_stream(parser, obj->value.closure.param, fout); */
    /* 	fprintf(fout," body:"); */
    /* 	output_stream(parser, obj->value.closure.body, fout); */
    /* 	fprintf(fout,">"); */
    /* 	last_closure=0; */
    /* 	break; */

    case VECTOR:
	fprintf(fout, "#(");
	
	/* walk the vector and output it's contents */
	for(i=0; i<obj->value.vector.length; i++) {
	    output_stream(parser, obj->value.vector.vector[i], fout);
	    
	    if(i+1<obj->value.vector.length) {
		fprintf(fout, " ");
	    }
	}

	fprintf(fout, ")");
	break;

    default:
	break;
    }
}

/* output to the standard output */
void output(parser_core_type *parser, object_type *obj) {
    output_stream(parser, obj, stdout);
}
