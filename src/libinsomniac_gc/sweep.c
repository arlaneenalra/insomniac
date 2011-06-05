#include "gc_internal.h"


/* walk every object in an object graph and mark it */
void mark_object(meta_obj_type *meta, mark_type mark) {

    /* don't change the mark on perm objects */
    if(meta->mark == PERM) {
        return;
    } else {
        meta->mark = mark;
    }
}


/* walk a graph of objects and mark them */
void mark_graph(gc_ms_type *gc, meta_obj_type *meta, mark_type mark) {
    meta_obj_ptr_def_type *root_list = 0;
    void *obj=0;
    void **next_obj=0;
    
    /* return if we don't have an object */
    if(!meta) {
        return;
    }

    /* we have already marked this object */
    if(meta->mark == mark) {
        return;
    }

    /* mark this object */
    mark_object(meta, mark);


    /* make sure this is a typed object */
    if(meta->type_def >= 0) {
        root_list = gc->type_defs[meta->type_def].root_list;
        
        /* walk the list of poitners internal to 
           this object */
        while(root_list) {
            
            /* calculate offset to pointer in objects */
            obj = obj_from_meta(meta);
            next_obj = (void **)((uint8_t *)obj + root_list->offset);
            
            /* mark any pointed to objects */
            mark_graph(gc, meta_from_obj(*next_obj), mark);
            
            root_list = root_list->next;
        }
    }
}

/* walk every object in a list and mark them */
void mark_list(gc_ms_type *gc, meta_obj_type *list, mark_type mark) {
    meta_obj_type *meta = 0;

    meta = list;
    while(meta) {
        mark_graph(gc, meta, mark);

        meta=meta->next;
    }
}

/* walk every object in a list and mark them */
void mark_root(gc_ms_type *gc, meta_root_type *list, mark_type mark) {
    meta_root_type *meta = 0;

    meta = list;
    while(meta) {
        mark_graph(gc, meta_from_obj(*(meta->root)), mark);

        meta=meta->next;
    }
}


/* move, unmarked objects to dead list */
void sweep_list(gc_ms_type * gc, mark_type mark) {
    meta_obj_type *active = gc->active_list;
    meta_obj_type *new_active = 0;
    meta_obj_type *dead = gc->dead_list;

    /* don't sweep if protection is active  */
    if(gc->protect_count) {
        return;
    }

    while(active) {
        meta_obj_type *next=active->next;
        
        /* do we have a dead object */
        if(active->mark == mark) {
            /* move our object to the head
               of the active list */
            active->next=new_active;
            new_active=active;
            
        } else {
            
            /* Do we have a cell sized object or
               something else? */
            if(active->size == gc->cell_size) {
                /* move our object to the head 
                   of the new dead list */
                active->next=dead;
                dead=active;
            } else {

                /* Free things that are not cell sized */
                FREE(active);
            }
        }

        active=next;
    }

    /* replace existing lists */
    gc->active_list=new_active;
    gc->dead_list=dead;
}


/* the guts of sweep */
void sweep(gc_ms_type *gc) {
    mark_type mark;

    assert(gc);

    if(gc->protect_count) {
        return;
    }

    mark = set_next_mark(gc);

    /* mark all reachable objects */
    mark_list(gc, gc->perm_list, mark);
    
    /* mark all objects reachable from our defined root 
       pointers */
    if(gc->root_list) {
        mark_root(gc, gc->root_list, mark);
    }

    /* iterate through the list of active nodes and 
       move the unmarked ones to dead */
    
    sweep_list(gc, mark);

    if(!gc->dead_list) {
        pre_alloc(gc);
    }

    printf("Swept");
    gc_stats(gc);
}

