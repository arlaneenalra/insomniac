#include "gc_internal.h"
#include <string.h>

/* Walk the graph of objects and copy them to the new space. */
void *copy_graph(gc_ms_type *gc, meta_obj_type *meta) {
    meta_obj_ptr_def_type *root_list = 0;
    int64_t size_max = 0;
    meta_obj_type *new_meta = 0;
    void *new_obj = 0;
    void **next_obj = 0;

    /* Return if we don't have an object. */
    if (!meta) {
        return 0;
    }

    /* Fixed objects are pinned -- return as-is without copying. */
    if (meta->mark == FIXED) {
        return obj_from_meta(meta);
    }

    /* If this object has already been copied, return the new data pointer.
       The forwarding address is stored in the meta header (size field)
       so that the original object data remains readable by stale C pointers. */
    if (meta->mark == FORWARDING) {
        return *((void **)&meta->size);
    }

    /* Allocate a new instance in the target space. */
    new_meta = internal_alloc(gc, meta->size);

    /* Copy the type definition. */
    new_meta->type_def = meta->type_def;

    /* Copy object data into the new data area (not the meta header). */
    new_obj = obj_from_meta(new_meta);
    memcpy(new_obj, (void *)obj_from_meta(meta), meta->size);

    /* Store the forwarding pointer in the meta header (size field)
       rather than in the object data, so stale C pointers can still
       read valid object data from the old pool. */
    meta->mark = FORWARDING;
    *((void **)&meta->size) = new_obj;

    /* If this is a typed object, we have other pointers to update. */
    if (meta->type_def >= 0) {
        /* Load the definition for this type of object. */
        root_list = gc->type_defs[meta->type_def].root_list;

        /* Walk the list of pointers internal to
           this object. */
        while (root_list) {
            /* Reference the new object pointer. */
            next_obj = (void **)((uint8_t *)new_obj + root_list->offset);

            switch (root_list->type) {
                case PTR:
                    /* Copy any child objects. */
                    (*next_obj) = copy_graph(gc, meta_from_obj(*next_obj));
                    break;

                case ARRAY:
                    /* Determine the size of the array based on size of the
                       allocation. Use new_meta->size since meta->size holds
                       the forwarding pointer. */
                    size_max = (new_meta->size / gc->type_defs[gc->array_type].size);

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

    /* Return the new data pointer (not the meta pointer). */
    return new_obj;
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

    /* Free the previous old pool (from last sweep).
       We defer freeing by one sweep cycle so that stale C pointers
       on the call stack can still read valid object data from the
       old pool until the next GC cycle. */
    if (gc->old_pool) {
        FREE(gc->old_pool);
    }

    /* Allocate a new memory pool. */
    gc->allocations = 0;
    gc->free = gc->pool_size;
    gc->memory_pool = gc->memory_pool_head = MALLOC(gc->pool_size);

    /* Mark all objects reachable from our defined root
       pointers. */
    if (gc->root_list) {
        copy_root(gc, gc->root_list);
    }

    /* Keep old pool alive for stale pointer access. */
    gc->old_pool = old_pool;

    gc_stats(gc, false);

    gc->sweeping = false;
}
