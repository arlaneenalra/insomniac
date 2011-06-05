#include "vm_internal.h"


/* create a list of pairs */
object_type *cons(gc_type *gc, object_type *car, object_type *cdr) {
    object_type *new_pair = 0;
    
    gc_protect(gc);

    new_pair = gc_alloc(gc, 0, sizeof(object_type));
    new_pair->type=PAIR;
    
    new_pair->value.pair.car = car;
    new_pair->value.pair.cdr = cdr;

    gc_unprotect(gc);
    
    return new_pair;
}
