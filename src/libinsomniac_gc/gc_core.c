#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <util.h>
#include <gc.h>


void internal_free_all(object_type *list);
void internal_set_next_mark(gc_core_type * gc);
void internal_mark(gc_mark_type mark, object_type *obj);

void internal_alloc_block(gc_core_type *gc);

uint64_t internal_count_list(object_type *list);

/* Create a new garbage collector instance */
gc_core_type *gc_create() {
    gc_core_type *gc=0;
    
    gc=(gc_core_type *)calloc(1, sizeof(gc_core_type));

    /* TODO: We need some error handling here ! */
    if(!gc) {
	return 0;
    }

    /* set default mark */
    gc->mark=RED;

    internal_alloc_block(gc);

    return gc;
}

/* Shutdown a collector instance */
void gc_destroy(gc_core_type *gc) {

    /* Nothing to clean up */
    if(!gc) {
	return;
    }

    /* free our lists of objects */
    internal_free_all(gc->active_list);
    internal_free_all(gc->dead_list);

    /* free our array of root pointers */
    free(gc->roots);
    
    free(gc);
}

/* Register a root pointer with the gc */
void gc_register_root(gc_core_type * gc, object_type **root_ptr) {
    
    object_type ***new_roots=0;
    
    /* allocate a new root array with one more element*/
    new_roots=calloc(gc->root_number+1,sizeof(object_type*));
    
    /* TODO:Come up with a better way to handle this */
    assert(new_roots);

    if(gc->roots) {

	/* copy old list of roots to the new array */
	memcpy(new_roots, gc->roots, (gc->root_number * sizeof(object_type*)));
	free(gc->roots);
    }
    
    new_roots[gc->root_number]=root_ptr;

    gc->roots=new_roots;
    gc->root_number++;    
}

/* run a manual sweep */
void gc_sweep(gc_core_type *gc) {
    gc_root_count_type i=0;

    object_type *obj=0;
    object_type *obj_next=0;
    
    /* setup the next mark */
    internal_set_next_mark(gc);

    /* Walk all of our root pointers and tree through their 
       referenced objects.  Mark the reachable objects with 
       the new mark. */

    TRACE("\nSWEEP");
    for(i=0;i<gc->root_number;i++) {
	obj=*(gc->roots[i]); /* get the object pointed to by this root */

	/* tree down and mark all reachable objects */
	internal_mark(gc->mark,obj);
	TRACE("\n");
    }

    /* now move all objects unmarked objects to the top of the dead list */
    
    obj=gc->active_list;
    gc->active_list=0; /* clear the active list */
    
    while(obj) {
	obj_next=obj->next;
	
	/* if our object is marked, add it to the live list */
	if(obj->mark == gc->mark) {
	    obj->next=gc->active_list;
	    gc->active_list=obj;
	} else {
	    /* otherwise, add it to the dead list */
	    obj->next=gc->dead_list;
	    gc->dead_list=obj;
	}
	
	/* move on to the next object */
	obj=obj_next;
    }

    gc_stats(gc);
    TRACE("\n");
}

/* Output some useful statistics about the garbage collector */
void gc_stats(gc_core_type * gc) {
    printf("\nGC:Active: %" PRIi64 ", Dead: %" PRIi64 ", Roots: %" PRIi64 "\n", 
	   internal_count_list(gc->active_list),
	   internal_count_list(gc->dead_list),
	   gc->root_number);    
}

/* Allocate a new blob within this gc */
object_type *gc_alloc_object(gc_core_type *gc) {

    object_type *obj=0;

    /* if there are no dead objects, do a sweep */
    if(!gc->dead_list) {
	gc_sweep(gc);
    }

    /* Are there any dead objects out there? */
    if(gc->dead_list) {
	TRACE("Gcp");

	/* pop an object off the top of the dead list */
	obj=gc->dead_list;
	gc->dead_list=obj->next;

	/* zero out the block */
	memset(obj, 0, sizeof(object_type));

    } else {
	TRACE("Gca");
	internal_alloc_block(gc); /* allocate a block of objects for next time */
	obj=(object_type *)calloc(1, sizeof(object_type));	
    }

    /* TODO: Add error checking */
    if(!obj) {
	return 0;
    }
    
    obj->mark=gc->mark;

    /* Attach to garbage collector */
    obj->next=gc->active_list;
    gc->active_list=obj;

    return obj;
}


/* free all objects in a list */
void internal_free_all(object_type *list) {
    object_type*next=list;

    while(list) {
	next=list->next;
	free(list);
	list=next;
    }
}

/* return the number of objects in a list of objects */
uint64_t internal_count_list(object_type *list) {
    uint64_t count=0;
    
    while(list) {
	count++;
	list=list->next;
    }
    return count;
}

/* figure out what the next mark is going to be */
void internal_set_next_mark(gc_core_type * gc) {
    
    /* we only have two marks */
    gc->mark=gc->mark==RED ? BLACK : RED;
}

/* tree through objects and mark them */
void internal_mark(gc_mark_type mark, object_type *obj) {
    TRACE("Gcm");
    
    /* walk until we run out of obects or see one that is
       already marked. */
    while(obj && obj->mark !=mark) {
	obj->mark=mark;

	switch (obj->type) {
	case TUPLE:
	case CHAIN:
	    TRACE("D");
	    internal_mark(mark, cdr(obj)); /* walk the other branch */	    
	    TRACE("A");
	    obj=car(obj);
	    break;

	default:
	    obj=0; /* nothing more to do here */
	}
    }
}


/* allocate a block of objects that can be used for gc_alloc_object */
void internal_alloc_block(gc_core_type *gc) {
    object_type * obj=0;
    
    for(int i=10; i>0; i--) {
	obj=(object_type *)calloc(1, sizeof(object_type));
	obj->next=gc->dead_list;
	gc->dead_list=obj;
    }
}
