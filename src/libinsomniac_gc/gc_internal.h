#ifndef _GC_INTERNAL_
#define _GC_INTERNAL_

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <assert.h>

#include <gc.h>

/* An internal GC structure to represent an allocated object */
typedef struct meta_obj meta_obj_type;
typedef struct meta_root meta_root_type;

struct meta_obj {
    object_type *obj; /* contained object */
    meta_obj_type *next; /* next object in our list */

};

struct meta_root {
    object_type **root;
    meta_root_type *next;
};

/* the internal type used by the GC to keep track of things */
typedef struct gc_ms {
    meta_obj_type *active_list; /* list of reachable objects */
    meta_obj_type *dead_list; /* list of unreachable objects */

    meta_obj_type *perm_list; /* list of objects we treat as permenant */

    meta_root_type *root_list; /* list of root pointers */

    vm_int protect_count;

    mark_type current_mark;
} gc_ms_type;

/* do the actual object allocation */
meta_obj_type *internal_alloc(gc_ms_type *gc, cell_type type);
void pre_alloc(gc_ms_type *gc);

/* clean up an allocated list of objects */
void destroy_list(meta_obj_type **list);

/* count how many objects are in a given list */
vm_int count_list(meta_obj_type **list);


/* Pick the next mark to use while sweeping */
mark_type set_next_mark(gc_ms_type *gc);

/* mark a list of root objects */
void mark_list(meta_obj_type *list, mark_type mark);
void mark_root(meta_root_type *list, mark_type mark);
void sweep_list(gc_ms_type *gc, mark_type mark);
void sweep(gc_ms_type *gc);

#endif
