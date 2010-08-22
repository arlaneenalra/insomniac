#ifndef _GC_
#define _GC_

#include <object.h>

/* this is arbitrary but should be enough */
typedef unsigned int gc_root_count_type;

/* Core components of the Garbage Collection Subsystem */
typedef struct gc_core {

    gc_mark_type mark;

    /* lists of active and dead objects */
    object_type *active_list;
    object_type *dead_list;

    /* list of objects created while protection 
       was turned on */
    uint64_t protect_count;
    object_type *protected_list;

    /* used to keep track of all our root pointers */
    gc_root_count_type root_number;
    object_type ***roots;
    
} gc_core_type;



/* function definitions */

gc_core_type *gc_create(); /* create and instance of the garbage collector */
void gc_destroy(gc_core_type *gc); /* shutdown the garbage collector instance */

void gc_sweep(gc_core_type *gc); /* force run a garbage collection cycle */

object_type *gc_alloc_object(gc_core_type *gc); /* allocate an object */
object_type *gc_alloc_object_type(gc_core_type *gc, object_type_enum type); /* allocate an object */

/* used to protect portions of code from garbage collection */
void gc_protect(gc_core_type *gc);
void gc_unprotect(gc_core_type *gc);

void gc_register_root(gc_core_type *gc, object_type **root_ptr); /* register a root pointer with the gc */

void gc_stats(gc_core_type *gc);

#endif
