#include "gc_internal.h"

/* construct a new instance of our GC */
gc_type *gc_create() {
    gc_ms_type *gc = MALLOC(gc_ms_type);

    return (gc_type *)gc;
}

/* deallocate a GC instance */
void gc_destroy(gc_type *gc_void) {
    if(gc_void) {
        /* cast back to our internal type */
        gc_ms_type *gc = (gc_ms_type *)gc_void;

        destroy_list(&(gc->active_list));
        destroy_list(&(gc->dead_list));

        FREE(gc);
    }
}

/* allocate an object and attach it to the gc */
object_type *gc_alloc(gc_type *gc_void, cell_type type) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    object_type *obj = internal_alloc(type);
    meta_obj_type *meta = MALLOC(meta_obj_type);

    /* make sure we have an object */
    assert(obj);
    assert(meta);

    /* attach the new object to our gc */
    meta->obj=obj;
    meta->next=gc->active_list;
    gc->active_list=meta;

    return obj;
}



/* walk a list and free every element in it */
void destroy_list(meta_obj_type **list) {
    meta_obj_type *meta=0;

    /* make sure there is a list to destroy */
    if(!list) {
        return;
    }

    /* retrieve the first list value */
    meta=*list;

    while(meta) {
        meta_obj_type *next=meta->next;

        /* free the object we are holding onto and
           the gc object */
        FREE(meta->obj);
        FREE(meta);

        /* move to the next object */
        meta=next;
    }

    /* null out this pointer */
    *list=0;
}

/* allocate an object */
object_type *internal_alloc(cell_type type) {
    object_type *obj=MALLOC(object_type);
    obj->type=type;
    return obj;
}


