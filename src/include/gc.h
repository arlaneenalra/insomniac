#ifndef _GC_
#define _GC_

#include "cell.h"   /* type definitions */
#include <stddef.h> /* for offsetof */
#include <stdlib.h> /* for the malloc lines */

/* structure that contains the core of our GC implementation */
typedef void gc_type;
typedef int32_t gc_type_def;

/* Setup and destroy functions. */
gc_type *gc_create(size_t cell_size);
void gc_destroy(gc_type *gc);

/* Sweep active objects. */
void gc_sweep(gc_type *gc);

/* Display statistics about GC. */
void gc_stats(gc_type *gc);

void gc_protect(gc_type *gc);
void gc_unprotect(gc_type *gc);

/* Allocate a new block. */
void gc_alloc(gc_type *gc, uint8_t perm, size_t size, void **ret);
void gc_alloc_type(gc_type *gc_void, uint8_t perm, gc_type_def, void **ret);
void gc_alloc_pointer_array(gc_type *gc_void, uint8_t perm, size_t cells, void **ret);

/* Explicitly make a cell not permenant. */
void gc_de_perm(gc_type *gc, void *cell);

/* Handling for root pointers. */
void gc_register_root(gc_type *gc_void, void **root);
void gc_unregister_root(gc_type *gc_void, void **root);

/* handling for type definitions. */
gc_type_def gc_register_type(gc_type *gc_void, size_t size);
void gc_register_pointer(gc_type *gc_void, gc_type_def type, size_t offset);

/* Register an array and a pointer to the size of the array.
 Size is assumed to be a 64bit integer. */
void gc_register_array(gc_type *gc_void, gc_type_def type, size_t offset);

/* Some utility functions. */
void gc_make_substring(gc_type *gc, const char *src, char **gc_str, int len);
#define gc_make_string(gc, src, gc_str) \
    gc_make_substring(gc, src, gc_str, strlen(src))

#endif
