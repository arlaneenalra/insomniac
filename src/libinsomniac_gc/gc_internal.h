#ifndef _GC_INTERNAL_
#define _GC_INTERNAL_

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <assert.h>

#include <stddef.h> /* for offsetof */

#include <gc.h>

/* An internal GC structure to represent an allocated object */
typedef struct meta_obj meta_obj_type;
typedef struct meta_root meta_root_type;

/* used by the GC to mark cells */
typedef enum mark {
    RED,
    BLACK,
    
    PERM
} mark_type;

struct meta_obj {
    meta_obj_type *next; /* next object in our list */
    mark_type mark;

    uint8_t obj[]; /* contained object */
    /* object_type obj; */
};

struct meta_root {
    void **root;
    meta_root_type *next;
};

/* the internal type used by the GC to keep track of things */
typedef struct gc_ms {
    meta_obj_type *active_list; /* list of reachable objects */
    meta_obj_type *dead_list; /* list of unreachable objects */

    meta_obj_type *perm_list; /* list of objects we treat as permenant */

    meta_root_type *root_list; /* list of root pointers */

    size_t cell_size;

    vm_int protect_count;

    mark_type current_mark;
} gc_ms_type;

/* do the actual object allocation */
meta_obj_type *internal_alloc(gc_ms_type *gc, uint8_t perm, size_t size);
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

/* used to convert between objects and meta objects */
meta_obj_type *meta_from_obj(void *obj);
void *obj_from_meta(meta_obj_type *meta);

/* offeset into a meta object for the actual object */
#define OBJECT_OFFSET offsetof(meta_obj_type, obj)

#endif
