#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <util.h>
#include <gc.h>


void free_all(object_type *list);
void set_next_mark_objects(gc_core_type * gc);
void mark_objects(gc_mark_type mark, object_type *obj);

void alloc_block(gc_core_type *gc);

uint64_t count_list(object_type *list);

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

    /* Allocate a starting block of Cells */
    alloc_block(gc);

    return gc;
}

/* Shutdown a collector instance */
void gc_destroy(gc_core_type *gc) {

    /* Nothing to clean up */
    if(!gc) {
	return;
    }

    /* free our lists of objects */
    free_all(gc->active_list);
    free_all(gc->dead_list);

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

    printf("\nSweep:");
    gc_stats(gc);
    
    /* setup the next mark */
    set_next_mark_objects(gc);

    /* Walk all of our root pointers and tree through their 
       referenced objects.  Mark the reachable objects with 
       the new mark. */

    for(i=0;i<gc->root_number;i++) {
	obj=*(gc->roots[i]); /* get the object pointed to by this root */

	/* tree down and mark all reachable objects */
	mark_objects(gc->mark,obj);
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

	} else if(obj->mark == PERM) {
	    /* move object out the list of active objects and
	       into our permenant object list. */
	    obj->next=gc->perm_list;
	    gc->perm_list=obj;

	} else {
	    /* otherwise, add it to the dead list */
	    obj->next=gc->dead_list;
	    gc->dead_list=obj;
	}
	
	/* move on to the next object */
	obj=obj_next;
    }
    
    gc_stats(gc);
}

/* Output some useful statistics about the garbage collector */
void gc_stats(gc_core_type * gc) {
    printf("\nGC:Active: %" PRIi64 ", Dead: %" PRIi64 ", Protected: %" PRIi64 ", "
	   "Permenant: %" PRIi64 ", Roots: %i, Depth: %" PRIi64 "\n", 
	   count_list(gc->active_list),
	   count_list(gc->dead_list),
	   count_list(gc->protected_list),
	   count_list(gc->perm_list),
	   gc->root_number,
	   gc->protect_count);    
}

/* Allocate a new blob within this gc */
object_type *gc_alloc_object(gc_core_type *gc) {

    object_type *obj=0;

    /* if there are no dead objects, do a sweep */
    if(!gc->dead_list && !gc->protect_count) {
	gc_sweep(gc);
    }

    /* Are there any dead objects out there? */
    if(gc->dead_list) {

	/* pop an object off the top of the dead list */
	obj=gc->dead_list;
	gc->dead_list=obj->next;

	/* zero out the block */
	memset(obj, 0, sizeof(object_type));

    } else {
	alloc_block(gc); /* allocate a block of objects for next time */
	obj=(object_type *)calloc(1, sizeof(object_type));	
    }

    /* TODO: Add error checking */
    if(!obj) {
	return 0;
    }
    
    obj->mark=gc->mark;

    /* Attach to garbage collector */
    if(gc->protect_count==0) {
	obj->next=gc->active_list;
	gc->active_list=obj;
    } else {
	obj->next=gc->protected_list;
	gc->protected_list=obj;
    }

    return obj;
}

/* return an object with the type preset */
object_type *gc_alloc_object_type(gc_core_type *gc, object_type_enum type) {
    object_type *obj=0;
    
    obj=gc_alloc_object(gc);
    
    if(obj) {
	obj->type=type;
    }

    return obj;
}

/* Turn allocated object protection on */
void gc_protect(gc_core_type *gc) {
    gc->protect_count++;
}

/* Turn off allocated object protection */
void gc_unprotect(gc_core_type *gc) {
    object_type *obj=0;
    
    gc->protect_count--;
    
    /* Something went wrong with protection counting */
    if(gc->protect_count<0) {
	fail("Too many unprotects!");
    }

    /* we can safely run the gc */
    if(gc->protect_count==0) {
	
	/* move protected objects into the active_list */
	obj=gc->protected_list;
	
	while(obj) {
	    gc->protected_list=obj->next;
	    obj->next=gc->active_list;
	    
	    /* we need to remark them since there could have
	       been a gc since protection was turned on */
	    obj->mark=gc->mark;
	    
	    /* attach and move to the next object */
	    gc->active_list=obj;
	    obj=gc->protected_list;
	}

	/* if there are no dead objects, let's do a collections */
	if(!gc->dead_list) {
	    gc_sweep(gc);
	}
    }
}

/* mark an object as permenant */
void gc_mark_perm(gc_core_type *gc, object_type *obj) {
    obj->mark=PERM;
}

/* free all objects in a list */
void free_all(object_type *list) {
    object_type *next=list;

    while(list) {
	next=list->next;

	/* handle any internal objects */
	switch(list->type) {
	case STRING:
	case SYM:
	    free(list->value.string_val);
	    break;
	    
	case VECTOR:
	    fail("Unimplemented");
	    break;

	default:
	    break;
	}

	free(list);
	list=next;
    }
}

/* return the number of objects in a list of objects */
uint64_t count_list(object_type *list) {
    uint64_t count=0;
    
    while(list) {
	count++;
	list=list->next;
    }
    return count;
}

/* figure out what the next mark is going to be */
void set_next_mark_objects(gc_core_type * gc) {
    
    /* we only have two marks */
    gc->mark=gc->mark==RED ? BLACK : RED;
}

/* tree through objects and mark them */
void mark_objects(gc_mark_type mark, object_type *obj) {
    
    /* Walk until we run out of obects or see one that is
       already marked. Objects marked permenant are treated 
       as marked. */
    while(obj && obj->mark != mark && obj->mark != PERM) {
	obj->mark=mark;

	switch (obj->type) {
	case TUPLE:
	case CHAIN:
	    mark_objects(mark, cdr(obj)); /* walk the other branch */	    
	    obj=car(obj);
	    break;

	case VECTOR:
	    fail("Unimplemented");
	    break;

	default:
	    obj=0; /* nothing more to do here */
	}
    }
}


/* allocate a block of objects that can be used for gc_alloc_object */
void alloc_block(gc_core_type *gc) {
    object_type * obj=0;
    
    for(int i=10; i>0; i--) {
	obj=(object_type *)calloc(1, sizeof(object_type));
	obj->next=gc->dead_list;
	gc->dead_list=obj;
    }
}
