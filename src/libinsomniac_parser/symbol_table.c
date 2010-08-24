#include <stdlib.h>
#include <string.h>

#include "parser_internal.h"


/* Our symbol table is structured like so: 

   ((1 . sym)
   (2 . sym2)
   (3 . sym3)

   ...

   . nil
   )
   
 */

/* Return a tuple that contains a pairing between a symbol and it's id 
   or creates a new symbol. */
object_type *symbol_sid_obj(parser_core_type *parser, char *sym) {
    object_type *obj=0;
    object_type *sid=0;

    /* Search the symbol table for our symbol first */
    obj=parser->symbols.list;

    while(obj) {
	
	/* compare the contained symbol to our passed in string */
	if(!strcmp(cdar(obj)->value.string_val, sym)) {
	    /* we found the symbol */
	    return car(obj);
	}

	obj=cdr(obj);
    }
    
    printf("New Symbol\n");
    /* ok, we didn't find the symbol, let's add a new one */
    gc_protect(parser->gc);

    /* allocate the symbol */
    obj=gc_alloc_string(parser->gc, sym);
    obj->type=SYM;
    gc_mark_perm(parser->gc, obj);
    
    /* set the id */
    sid=gc_alloc_object_type(parser->gc, FIXNUM);
    sid->value.int_val=parser->symbols.sid++;
    gc_mark_perm(parser->gc, sid);
    
    /* add it to the symbol list */
    obj=cons(parser, sid, obj);
    gc_mark_perm(parser->gc, obj);

    obj=cons(parser, obj, parser->symbols.list);
    gc_mark_perm(parser->gc, obj);

    parser->symbols.list=obj;

    gc_unprotect(parser->gc);
    printf("Done\n");

    printf("Current Symbols:");
    output(parser, parser->symbols.list);

    return car(obj);
}

/* return an instance of the object representing a symbol */
object_type *symbol_obj(parser_core_type *parser, char *sym) {
    
    return cdr(symbol_sid_obj(parser, sym));
}

object_type *symbol_sid(parser_core_type *parser, char *sym) {
    
    return car(symbol_sid_obj(parser, sym));
}
