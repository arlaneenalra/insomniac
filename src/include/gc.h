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
void *gc_alloc(gc_type *gc, cell_type type);
void *gc_perm_alloc(gc_type *gc, cell_type type);

/* explicitly make a cell not permenant */
void gc_de_perm(gc_type *gc, void *cell);

/* handling for root pointers */
void gc_register_root(gc_type *gc_void, void **root);
void gc_unregister_root(gc_type *gc_void, void **root);

/* deal with these as a macro incase I need to change them latter */
#define MALLOC(size) calloc(1, size)
#define MALLOC_TYPE(type) (type *)MALLOC(sizeof(type))
#define FREE(ptr) free(ptr)


#endif
