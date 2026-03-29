#include "gc_internal.h"
#include <string.h>

/* Walk the graph of objects and copy them to the new space. */
void *copy_graph(gc_ms_type *gc, meta_obj_type *meta) {
    meta_obj_ptr_def_type *root_list = 0;
    int64_t size_max = 0;
    void *obj = 0;
    void **next_obj = 0;

    /* Return if we don't have an object. */
    if (!meta) {
        return 0;
    }

    /* If this object has already been copied, return the new pointer. */
    if (meta->mark == FORWARDING) {
        return *((void **)obj_from_meta(meta));
    }

    /* Allocate a new instance in the target space and copy our data into it. */
    obj = internal_alloc(gc, meta->size);
    memcpy(obj, (void *)obj_from_meta(meta), meta->size);

    /* Create the forwarding pointer. */
    meta->mark = FORWARDING;
    *((void **)obj_from_meta(meta)) = obj; 

    /* If this is a typed object, we have other pointers to update. */
    if (meta->type_def >= 0) {
        /* Load the definition for this type of object. */
        root_list = gc->type_defs[meta->type_def].root_list;

        /* Walk the list of pointers internal to
           this object. */
        while (root_list) {
            /* Reference the new object pointer. */
            next_obj = (void **)((uint8_t *)obj + root_list->offset);

            switch (root_list->type) {
                case PTR:
                    /* Copy any child objects. */
                    (*next_obj) = copy_graph(gc, meta_from_obj(*next_obj));
                    break;

                case ARRAY:
                    /* Determine the size of the array based on size of the
                       allocation. */
                    size_max = (meta->size / gc->type_defs[gc->array_type].size);

                    /* Copy all child objects. */
                    for (int idx = 0; idx < size_max; idx++) {
                        next_obj[idx] = copy_graph(gc, meta_from_obj(next_obj[idx]));
                    }

                    break;

                default:
                    assert(0);
                    break;
            }

            root_list = root_list->next;
        }
    }

    return obj;
}

/* Copy all objects associated to a root. */
void copy_root(gc_ms_type *gc, meta_root_type *list) {
    meta_root_type *meta = 0;

    meta = list;
    while (meta) {
        *(meta->root) = copy_graph(gc, meta_from_obj(*(meta->root)));

        meta = meta->next;
    }
}

/* The guts of sweep. */
void sweep(gc_ms_type *gc) {
    uint8_t *old_pool = gc->memory_pool;
    
    assert(gc);
    assert(!gc->sweeping);

    /* Check protection status before sweeping */
    if (gc->protect_count) {
        return;
    }
    
    gc_stats(gc, true);
    
    gc->sweeping = true;
    
    gc->sweeps++;

    /* Allocate a new memory pool. */
    gc->allocations = 0;
    gc->free = gc->pool_size;
    gc->memory_pool = gc->memory_pool_head = MALLOC(gc->pool_size);

    /* Mark all objects reachable from our defined root
       pointers. */
    if (gc->root_list) {
        copy_root(gc, gc->root_list);
    }

    /* Clean up old pool. */
    FREE(old_pool);
    
    gc_stats(gc, false);

    gc->sweeping = false;
}
