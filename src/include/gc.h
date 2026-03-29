#ifndef _GC_
#define _GC_

#include <stddef.h> /* for offsetof */
#include <stdlib.h> /* for the malloc lines */

#include "types.h"

/* structure that contains the core of our GC implementation */
typedef void gc_type;
typedef int32_t gc_type_def;

/* Setup and destroy functions. */
/* TODO: add a runtime CLI option (e.g. --pool-size=<bytes>) to pass a
 * user-supplied value here instead of always using 0 (default). */
gc_type *gc_create(size_t cell_size, size_t pool_size);
void gc_destroy(gc_type *gc);

/* Returns the default pool size: 40% of physical RAM, capped at 1 GB.
 * Falls back to GC_INITIAL_FREE if system memory detection fails. */
size_t gc_default_pool_size(void);

/* Sweep active objects. */
void gc_sweep(gc_type *gc);

/* Display statistics about GC. */
void gc_stats(gc_type *gc, bool start);

void gc_protect(gc_type *gc);
void gc_unprotect(gc_type *gc);

/* Allocate a new block. */
void gc_alloc(gc_type *gc, size_t size, void **ret);
void gc_alloc_type(gc_type *gc_void, gc_type_def, void **ret);
void gc_alloc_pointer_array(gc_type *gc_void, size_t cells, void **ret);

/* Handling for root pointers. */
void gc_register_root(gc_type *gc_void, void **root);
void gc_unregister_root(gc_type *gc_void, void **root);

/* handling for type definitions. */
gc_type_def gc_register_type(gc_type *gc_void, size_t size);
void gc_register_pointer(gc_type *gc_void, gc_type_def type, size_t offset);

/* Register an array and a pointer to the size of the array.
 Size is assumed to be a 64bit integer. */
void gc_register_array(gc_type *gc_void, gc_type_def type, size_t offset);

/* Check if a pointer is in the old (stale) pool. For debugging. */
bool gc_is_stale(gc_type *gc, void *ptr);

/* Enable pointer validation during GC sweep.
   When enabled, copy_graph verifies that every pointer it follows
   resides in the expected memory pool (the from-space), and that
   forwarding addresses land in the to-space. Crashes immediately
   with diagnostic output on violation. */
void gc_set_validate(gc_type *gc, bool enable);

/* Enable or disable verbose GC reporting.
   When enabled, gc_stats prints allocation counts, sweep counts, and
   free memory before and after each sweep. */
void gc_verbose_reporting(gc_type *gc, bool enable);

/* Some utility functions. */
void gc_make_substring(gc_type *gc, const char *src, char **gc_str, int len);
#define gc_make_string(gc, src, gc_str) \
    gc_make_substring(gc, src, gc_str, strlen(src))

#endif
