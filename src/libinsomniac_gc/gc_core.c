#include "gc_internal.h"

#include "stdio.h" /* for gc_stats */

/* construct a new instance of our GC */
gc_type *gc_create(size_t cell_size) {
    gc_ms_type *gc = MALLOC_TYPE(gc_ms_type);
    
    gc->current_mark = RED;
    gc->protect_count = 0;
    gc->cell_size = cell_size;

    /* used to keep track of type definitions */
    gc->type_defs = 0;
    gc->num_types = 0;

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

        destroy_types(gc->type_defs, gc->num_types);

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

    /* make sure we have paired protects */
    assert(gc->protect_count >= 0);

    if(!gc->protect_count && !gc->dead_list) {
        sweep(gc);
    }
}

/* register a root pointer */
void gc_register_root(gc_type *gc_void, void **root) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_root_type *meta = MALLOC_TYPE(meta_root_type);

    meta->root = root;
    meta->next = gc->root_list;

    gc->root_list = meta;
}

/* unregister a root point */
/* TODO: This is going to be very inefficient */
void gc_unregister_root(gc_type *gc_void, void **root) {
    gc_ms_type *gc=(gc_ms_type *)gc_void;
    meta_root_type *meta = gc->root_list;
    meta_root_type *prev = 0;


    /* search until we find an object that matches our root pointer */
    while(meta->next && meta->root != root) {
        prev = meta;
        meta = meta->next;
    }

    /* we are not the first element in the list */
    if(prev) {
        prev->next = meta->next;
    } else { /* it was the first item on the list */
        gc->root_list = meta->next;
    }

    /* this is really inefficient */
    FREE(meta);    
}

/* allocate an object and attach it to the gc */
void *gc_alloc(gc_type *gc_void, uint8_t perm, size_t size) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_type *meta = internal_alloc(gc, perm, size);

    return obj_from_meta(meta); 
}


/* remove permenant status from a given cell */
void gc_de_perm(gc_type *gc_void, void *obj_in) {
    gc_ms_type *gc=(gc_ms_type *)gc_void;
    meta_obj_type *meta = gc->perm_list;
    meta_obj_type *prev = 0;

    meta_obj_type *obj=meta_from_obj(obj_in);

    /* nothing to unmark */
    if(obj->mark != PERM) {
        return;
    }

    /* mark the object as though we just created it */
    obj->mark = gc->current_mark;

    /* search for our object in the perm list */
    while(meta->next && meta != obj) {
        prev = meta;
        meta = meta->next;
    }

    /* we are not the first element in the list */
    if(prev) {
        prev->next = meta->next;
    } else { /* it was the first item on the list */
        gc->perm_list = meta->next;
    }

    /* attach our object to the top of the active list */
    meta->next = gc->active_list;
    gc->active_list = meta;
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

