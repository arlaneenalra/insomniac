#ifndef _GC_
#define _GC_

#include "cell.h" /* type definitions */
#include <stdlib.h> /* for the malloc lines */
#include <stddef.h> /* for offsetof */

/* structure that contains the core of our GC implementation */
typedef void gc_type;
typedef int32_t gc_type_def;

/* setup and destroy functions */
gc_type *gc_create(size_t cell_size);
void gc_destroy(gc_type *gc);

/* sweep active objects */
void gc_sweep(gc_type *gc);

/* display statistics about GC */
void gc_stats(gc_type *gc);

void gc_protect(gc_type *gc);
void gc_unprotect(gc_type *gc);

/* allocate a new block */
void *gc_alloc(gc_type *gc, uint8_t perm, size_t size);
void *gc_alloc_type(gc_type *gc_void, uint8_t perm, gc_type_def);
void *gc_alloc_array_type(gc_type *gc_void, uint8_t perm, gc_type_def, size_t cells);

/* explicitly make a cell not permenant */
void gc_de_perm(gc_type *gc, void *cell);

/* handling for root pointers */
void gc_register_root(gc_type *gc_void, void **root);
void gc_unregister_root(gc_type *gc_void, void **root);

/* handling for type definitions */
gc_type_def gc_register_type(gc_type *gc_void, size_t size);
void gc_register_pointer(gc_type *gc_void, gc_type_def type, size_t offset);

/* register an array and a pointer to the size of the array.
 Size is assumed to be a 64bit integer */
void gc_register_array(gc_type *gc_void, gc_type_def type, size_t offset);

/* deal with these as a macro incase I need to change them latter */
#define MALLOC(size) calloc(1, size)
#define MALLOC_TYPE(type) (type *)MALLOC(sizeof(type))
#define FREE(ptr) free(ptr)


#endif
