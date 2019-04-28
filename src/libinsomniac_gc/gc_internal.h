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

/* used for type definitions */
typedef struct meta_obj_def meta_obj_def_type;
typedef struct meta_obj_ptr_def meta_obj_ptr_def_type;

/* used by the GC to mark cells */
typedef enum mark {
    RED,
    BLACK,

    PERM,
    DEAD
} mark_type;

/* are we looking at a pointer or an array */
typedef enum meta_ptr {
    PTR,
    ARRAY
} meta_ptr_type;

/* meta object wrapper */
struct meta_obj {
    meta_obj_type *next; /* next object in our list */
    mark_type mark;
    size_t size;
    gc_type_def type_def;

    uint8_t obj[]; /* contained object */
    /* object_type obj; */
};

/* root pointers that need to be searched */
struct meta_root {
    void **root;
    meta_root_type *next;
};

/* used to store offsets to pointers in objects */
struct meta_obj_def {
    size_t size;
    meta_obj_ptr_def_type *root_list;
};

/* offset to a pointer in the object */
struct meta_obj_ptr_def {
    meta_ptr_type type;
    size_t offset;
    /* size_t offset_to_size; */
    meta_obj_ptr_def_type *next;
};


/* the internal type used by the GC to keep track of things */
typedef struct gc_ms {
    meta_obj_type *active_list; /* list of reachable objects */
    meta_obj_type *dead_list; /* list of unreachable objects */

    meta_obj_type *perm_list; /* list of objects we treat as permenant */

    meta_root_type *root_list; /* list of root pointers */

    meta_obj_def_type *type_defs; /* definitions of various types */
    uint32_t num_types; /* number of types */

    size_t cell_size; /* size of a normal cell */
    size_t size_granularity; /* the actual size of a normal cell*/

    vm_int protect_count;

    vm_int allocations; /* Total number of active allocations */

    mark_type current_mark;

    gc_type_def array_type; /* typedef for pointer arrays */
} gc_ms_type;

/* do the actual object allocation */
meta_obj_type *internal_alloc(gc_ms_type *gc, uint8_t perm, size_t size);
void pre_alloc(gc_ms_type *gc);

/* clean up an allocated list of objects */
void destroy_list(gc_ms_type *gc, meta_obj_type **list);
void destroy_types(gc_ms_type *gc, meta_obj_def_type *type_list, uint32_t num_types);

/* count how many objects are in a given list */
vm_int count_list(meta_obj_type **list);


/* Pick the next mark to use while sweeping */
mark_type set_next_mark(gc_ms_type *gc);

/* mark a list of root objects */
void mark_list(gc_ms_type *gc, meta_obj_type *list, mark_type mark);
void mark_root(gc_ms_type *gc, meta_root_type *list, mark_type mark);
void sweep_list(gc_ms_type *gc, mark_type mark);
void sweep(gc_ms_type *gc);

/* used to convert between objects and meta objects */
meta_obj_type *meta_from_obj(void *obj);
void *obj_from_meta(meta_obj_type *meta);

void *gc_malloc(gc_ms_type *gc, size_t size);
void gc_free(gc_ms_type *gc, void *obj);

/* offeset into a meta object for the actual object */
#define OBJECT_OFFSET offsetof(meta_obj_type, obj)

/* deal with these as a macro incase I need to change them latter */
/* #define MALLOC(size) calloc(1, size) */
#define MALLOC(size) gc_malloc(gc, size)
#define MALLOC_TYPE(type) (type *)MALLOC(sizeof(type))
/* #define FREE(ptr) free(ptr) */
#define FREE(ptr) gc_free(gc, ptr);


#endif
