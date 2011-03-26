#include "gc_internal.h"

#include "stdio.h" /* for gc_stats */

/* construct a new instance of our GC */
gc_type *gc_create() {
    gc_ms_type *gc = MALLOC(gc_ms_type);
    
    gc->current_mark = RED;
    gc->protect_count = 0;

    return (gc_type *)gc;
}

/* deallocate a GC instance */
void gc_destroy(gc_type *gc_void) {
    if(gc_void) {
        /* cast back to our internal type */
        gc_ms_type *gc = (gc_ms_type *)gc_void;

        destroy_list(&(gc->active_list));
        destroy_list(&(gc->dead_list));
        destroy_list(&(gc->perm_list));

        FREE(gc);
    }
}


/* increment the protect counter */
void gc_protect(gc_type *gc_void) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    gc->protect_count++;
}

/* increment the protect counter */
void gc_unprotect(gc_type *gc_void) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    gc->protect_count--;

    if(!gc->protect_count && !gc->dead_list) {
        sweep(gc);
    }
}

/* allocate an object and attach it to the gc */
object_type *gc_alloc(gc_type *gc_void, cell_type type) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_type *meta = internal_alloc(gc, type);

    /* attach the new object to our gc */
    meta->next = gc->active_list;
    gc->active_list = meta;

    return meta->obj; 
}

/* allocate a permenant object, one that does not get GCd */
object_type *gc_perm_alloc(gc_type *gc_void, cell_type type) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_type *meta = internal_alloc(gc, type);

    meta->obj->mark = PERM;

    /* attach the new object to our gc */
    meta->next = gc->perm_list;
    gc->perm_list = meta;

    return meta->obj;
}

/* output some useful statistics about the GC */
void gc_stats(gc_type *gc_void) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    vm_int active = 0;
    vm_int dead = 0; 
    vm_int perm = 0;

    assert(gc);

    active=count_list(&(gc->active_list));
    dead=count_list(&(gc->dead_list));
    perm=count_list(&(gc->perm_list));

    printf("GC statistics active:%" PRIi64 " dead:%" PRIi64 " perm:%" PRIi64 "\n",
           active, dead, perm);
}

/* initiate a sweep of objects in the active list */
void gc_sweep(gc_type *gc_void) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;

    sweep(gc);
}

