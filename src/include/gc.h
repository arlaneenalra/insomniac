#ifndef _GC_
#define _GC_

#include "cell.h" /* type definitions */

/* structure that contains the core of our GC implementation */
typedef void gc_type;

/* setup and destroy functions */
gc_type *gc_create();
void gc_destroy(gc_type *gc);

/* allocate a new object */
object_type *gc_alloc(gc_type *gc, cell_type type);

#endif
