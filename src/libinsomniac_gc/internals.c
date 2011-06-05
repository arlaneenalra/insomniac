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
void destroy_list(meta_obj_type **list) {
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
meta_obj_type *internal_alloc(gc_ms_type *gc, cell_type type) {
    void *obj = 0; 
    meta_obj_type *meta = 0;

    /* if there are no available objects, sweep */
    if(!gc->dead_list) {
        sweep(gc);
    }

    if(gc->dead_list) {
        /* reuse an object */
        meta = gc->dead_list;
        gc->dead_list = meta->next;
        obj = obj_from_meta(meta);

        bzero(obj, sizeof(object_type)); /* zero out our object */
    } else {
        /* create a new obect */

        /* TODO: fix this */
        meta = MALLOC(sizeof(meta_obj_type)+sizeof(object_type));
        obj = obj_from_meta(meta);
    }

    /* make sure we have an object */
    assert(meta);

    /* TODO: Fix this */
    ((object_type *)obj)->type = type;
    meta->mark = gc->current_mark;

    return meta;
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
    meta_obj_type *meta = 0;
    meta_obj_type *new_dead = 0;

    gc_protect(gc);
    
    for(int i = 0; i < 500; i++) {
        meta = internal_alloc(gc, FIXNUM);
        meta->next = new_dead;
        new_dead = meta;
    }
    
    gc->dead_list = new_dead;
    gc_unprotect(gc);
}


/* return a pointer to the meta object for a given object */
meta_obj_type *meta_from_obj(void *obj) {
    /* make sure a null stays a null */
    if(!obj) {
        return 0;
    }

    return (meta_obj_type *)(((uint8_t *)obj)-offsetof(meta_obj_type, obj));
}

/* return a pointer to the given object for a given meta object */
void *obj_from_meta(meta_obj_type *meta) {
    if(!meta) {
        return 0;
    }

    return &(meta->obj);
}
