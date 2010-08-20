#ifndef _GC_
#define _GC_

#include <object.h>

/* this is arbitrary but should be enough */
typedef uint16_t gc_root_count_type;

/* Core components of the Garbage Collection Subsystem */
typedef struct gc_core {

    gc_mark_type mark;

    /* lists of active and dead objects */
    object_type *active_list;
    object_type *dead_list;

    /* used to keep track of all our root pointers */
    gc_root_count_type root_number;
    object_type ***roots;
    
} gc_core_type;



/* function definitions */

gc_core_type *gc_create(); /* create and instance of the garbage collector */
void gc_destroy(gc_core_type *gc); /* shutdown the garbage collector instance */

void gc_sweep(gc_core_type *gc); /* force run a garbage collection cycle */

object_type *gc_alloc_object(gc_core_type *gc); /* allocate an object */

void gc_register_root(gc_core_type *gc, object_type **root_ptr); /* register a root pointer with the gc */

void gc_stats(gc_core_type *gc);

#endif
