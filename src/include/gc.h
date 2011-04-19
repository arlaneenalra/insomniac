#ifndef _GC_
#define _GC_

#include "cell.h" /* type definitions */
#include <stdlib.h> /* for the malloc lines */

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

/* explicitly make a cell not permenant */
void gc_de_perm(gc_type *gc, object_type *cell);

/* handling for root pointers */
void gc_register_root(gc_type *gc_void, object_type **root);
void gc_unregister_root(gc_type *gc_void, object_type **root);

/* deal with these as a macro incase I need to change them latter */
#define MALLOC(type) (type *)calloc(1, sizeof(type))
#define FREE(ptr) free(ptr)


#endif
