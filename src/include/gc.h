#ifndef _GC_
#define _GC_

#include "cell.h" /* type definitions */

/* structure that contains the core of our GC implementation */
typedef void gc_type;

/* setup and destroy functions */
gc_type *gc_create();
void gc_destroy(gc_type *gc);

/* sweep active objects */
void gc_sweep(gc_type *gc);

/* display statistics about GC */
void gc_stats(gc_type *gc);

void gc_protect(gc_type *gc);
void gc_unprotect(gc_type *gc);

/* allocate a new object */
object_type *gc_alloc(gc_type *gc, cell_type type);
object_type *gc_perm_alloc(gc_type *gc, cell_type type);

#endif
