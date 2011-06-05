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
void mark_graph(meta_obj_type *meta, mark_type mark) {
    
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

    /* TODO: Fix this */
    object_type *obj=obj_from_meta(meta);

    switch(obj->type) {
    case FIXNUM:
        break;

    case PAIR: /* need to iterate through child objects */
        /* TODO: I need to find a way to iterate over these */
        mark_graph(meta_from_obj(obj->value.pair.car), mark);
        mark_graph(meta_from_obj(obj->value.pair.cdr), mark);
        
        break;

    case EMPTY: /* nothing to do with this one */
        break;

    default:
        assert(0);
    }
}

/* walk every object in a list and mark them */
void mark_list(meta_obj_type *list, mark_type mark) {
    meta_obj_type *meta = 0;

    meta = list;
    while(meta) {
        mark_graph(meta, mark);

        meta=meta->next;
    }
}

/* walk every object in a list and mark them */
void mark_root(meta_root_type *list, mark_type mark) {
    meta_root_type *meta = 0;

    meta = list;
    while(meta) {
        mark_graph(meta_from_obj(*(meta->root)), mark);

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
               of the dead list */
            active->next=new_active;
            new_active=active;
        } else {
            /* move our object to the head 
               of the new active list */
            active->next=dead;
            dead=active;
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
    mark_list(gc->perm_list, mark);
    
    /* mark all objects reachable from our defined root 
       pointers */
    if(gc->root_list) {
        mark_root(gc->root_list, mark);
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