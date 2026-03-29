#include "gc_internal.h"
#include "sys/param.h"

/* allocate an object */
meta_obj_type *internal_alloc(gc_ms_type *gc, size_t size) {
    meta_obj_type *meta = 0;
    size_t real_size = 0;

    /* Adjust the a given allocation to the minimum size needed.
       i.e. we have to have enough room for a forwarding pointer later. */
    size = MAX(size, sizeof(void *));
    real_size = sizeof(meta_obj_type) + size;
        
    assert(real_size > 0);

    /* Add on to the number of allocations. */
    gc->allocations++;

    /* Subtract allocated amout from available memory. */
    gc->free -= real_size;

    /* If there is no memory left, sweep. */
    if (gc->free < 0) {
        sweep(gc);
        gc->free -= real_size;
    }
  
    /* Make sure we actually freed up some memory. */
    assert(gc->free > 0);
 
    /* Allocate a chunk of memory from the pool. */ 
    meta = (meta_obj_type *)gc->memory_pool_head;

    /* Update head pointer to the next available readon. */
    gc->memory_pool_head += real_size;

    /* Set the allocated size of the meta object. */
    meta->size = size;

    /* Mark this as a real object. */
    meta->mark = LIVE;

    return meta;
}

