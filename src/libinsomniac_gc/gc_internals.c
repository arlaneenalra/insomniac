#include "gc_internal.h"


vm_int count_list(meta_obj_type **list) {
    vm_int count = 0;
    meta_obj_type *meta = 0;

    meta = *list;
    while(meta) {
        count++;
        meta = meta->next;
    }

    return count;
}

/* walk a list and free every element in it */
void destroy_list(gc_ms_type *gc, meta_obj_type **list) {
    meta_obj_type *meta = 0;

    /* retrieve the first list value */
    meta = *list;
    while(meta) {
        meta_obj_type *next = meta->next;

        /* free the object we are holding onto and
           the gc object */
        FREE(meta);

        /* move to the next object */
        meta = next;
    }

    /* null out this pointer */
    *list = 0;
}

/* allocate an object */
meta_obj_type *internal_alloc(gc_ms_type *gc, uint8_t perm, size_t size) {
    meta_obj_type *meta = 0;
    size_t real_size = 0;

    /* adjust the requested size with
       the size of our meta object */
    real_size = sizeof(meta_obj_type)+size;

    /* only attempt reuse on cell sized objects */
    if(size == gc->cell_size) {

        /* if there are no available objects, sweep */
        if(!gc->dead_list) {
            sweep(gc);
        }

        /* only attempt reallocation for cell sized things */
        if(gc->dead_list) {
            /* reuse an object */
            meta = gc->dead_list;
            gc->dead_list = meta->next;

            bzero(meta, real_size); /* zero out our object */
        }
    }

    /* If we didn't find an object,
       create one. */
    if(!meta) {
        /* create a new obect */
        meta = MALLOC(real_size);
    }

    /* reset the allocation size */
    meta->size=size;

    /* make sure we have an object */
    assert(meta);

    /* Attach a permenant object to
       the list of perm objects */
    if(perm) {
        meta->mark = PERM;

        /* attach the new object to our gc */
        meta->next = gc->perm_list;
        gc->perm_list = meta;

    } else {
        meta->mark = gc->current_mark;
        /* attach the new object to our gc */
        meta->next = gc->active_list;
        gc->active_list = meta;
    }

    return meta;
}

/* allocate but only based on a multiple of gc->size_granulartiy */
void *gc_malloc(gc_ms_type *gc, size_t size) {
    size_t real_size = size;

    /* if we have a gc, use size_granularity */
    if(gc) {
        real_size += gc->size_granularity -
            (real_size % gc->size_granularity);
        gc->allocations++;
    }

    //return calloc(1, real_size);
    return calloc(real_size, 1);
}

/* Count frees */
void gc_free(gc_ms_type *gc, void *obj) {
    if(gc) {
        gc->allocations--;
    }
    free(obj);
}

/* determine what the next mark will be for created objects */
mark_type set_next_mark(gc_ms_type *gc) {
    mark_type mark = gc->current_mark;
    mark = mark == RED ? BLACK : RED;
    return gc->current_mark = mark;
}

/* preallocate a chunk of memory, only use with an empty
   dead list */
void pre_alloc(gc_ms_type *gc) {
    void *obj=0;

    gc_protect(gc);

    for(int i = 0; i < 1000; i++) {
        gc_alloc(gc, 0, gc->cell_size, (void**)&obj);
    }

    gc_unprotect(gc);
    gc_sweep(gc); /* sweep the garbage collector */
}

