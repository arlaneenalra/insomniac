#include "gc_internal.h"

#include "stdio.h"

/* Construct a new instance of our GC. */
gc_type *gc_create(size_t cell_size) {
    gc_ms_type *gc = 0;
    gc = MALLOC_TYPE(gc_ms_type);

    gc->protect_count = 0;

    /* Used to keep track of type definitions. */
    gc->type_defs = 0;
    gc->num_types = 0;

    /* Allocate the initial pool. */
    gc->pool_size = gc->free = GC_INITIAL_FREE;
    gc->memory_pool = gc->memory_pool_head = MALLOC(GC_INITIAL_FREE);

    /* Register the ARRAY type as type 0. */
    gc->array_type = gc_register_type(gc, sizeof(void *));
    gc_register_array(gc, gc->array_type, 0);

    return (gc_type *)gc;
}

/* deallocate a GC instance */
void gc_destroy(gc_type *gc_void) {
    meta_root_type *root = 0;

    if (gc_void) {
        /* cast back to our internal type */
        gc_ms_type *gc = (gc_ms_type *)gc_void;

        destroy_types(gc, gc->type_defs, gc->num_types);

        /* Destroy roots */
        root = gc->pruned_root_list;
        while(root) {
            meta_root_type *next = root->next;
            FREE(root);
            root = next;
        }

        root = gc->root_list;
        while(root) {
            meta_root_type *next = root->next;
            FREE(root);
            root = next;
        }

        FREE(gc->memory_pool);
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
}

/* register a root pointer */
void gc_register_root(gc_type *gc_void, void **root) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_root_type *meta = 0;

    if (gc->pruned_root_list) {
        meta = gc->pruned_root_list;
        gc->pruned_root_list = meta->next;
    } else {
        meta = MALLOC_TYPE(meta_root_type);
    }

    meta->root = root;
    meta->next = gc->root_list;

    gc->root_list = meta;
}

/* unregister a root point */
/* TODO: This is going to be very inefficient */
void gc_unregister_root(gc_type *gc_void, void **root) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_root_type *meta = gc->root_list;
    meta_root_type *prev = 0;

    /* search until we find an object that matches our root pointer */
    while (meta->next && meta->root != root) {
        prev = meta;
        meta = meta->next;
    }

    /* do a sanity check to make sure we're unregistering what we mean to. */
    assert(meta->root == root);

    /* we are not the first element in the list */
    if (prev) {
        prev->next = meta->next;
    } else { /* it was the first item on the list */
        gc->root_list = meta->next;
    }

    /* Save the meta object for later reuse. */
    meta->next = gc->pruned_root_list;
    gc->pruned_root_list = meta;
}

/* allocate a blob and attach it to the gc */
void gc_alloc(gc_type *gc_void, size_t size, void **ret) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_type *meta = internal_alloc(gc, size);

    /* mark as being untyped */
    meta->type_def = -1;

    /* return obj_from_meta(meta);*/
    *ret = obj_from_meta(meta);
}

/* allocate a type and attach it to the gc */
void gc_alloc_type(gc_type *gc_void, gc_type_def type, void **ret) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_def_type *type_ptr = &(gc->type_defs[type]);
    meta_obj_type *meta = internal_alloc(gc, type_ptr->size);

    meta->type_def = type;

    /* return obj_from_meta(meta); */
    *ret = obj_from_meta(meta);
}

/* allocate an array and attach it to the gc */
void gc_alloc_pointer_array(gc_type *gc_void, size_t cells, void **ret) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_def_type *type_ptr = &(gc->type_defs[gc->array_type]);
    meta_obj_type *meta = 0;

    meta = internal_alloc(gc, type_ptr->size * cells);

    meta->type_def = gc->array_type;

    /* return obj_from_meta(meta); */
    *ret = obj_from_meta(meta);
}

/* output some useful statistics about the GC */
void gc_stats(gc_type *gc_void, bool start) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;

    assert(gc);

    if (start) {
        printf("Before: ");
    } else {
        printf("After : ");
    }

    printf(
        "GC statistics Allocations : %" PRIi64
            " Sweeps: %" PRIi64 " Free: %" PRIi64 "\n",
        gc->allocations, gc->sweeps, gc->free);
}

/* initiate a sweep of objects in the active list */
void gc_sweep(gc_type *gc_void) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;

    sweep(gc);
}
