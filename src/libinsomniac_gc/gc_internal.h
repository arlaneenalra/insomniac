#ifndef _GC_INTERNAL_
#define _GC_INTERNAL_

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

#include <stddef.h> /* for offsetof */

#ifdef __APPLE__
#include <sys/sysctl.h>
#endif
#ifdef __linux__
#include <unistd.h>
#endif

#include <gc.h>

/* Fallback pool size used when system memory detection fails. */
/* #define GC_INITIAL_FREE 0x1000000 */
#define GC_INITIAL_FREE 0x100000000

/* An internal GC structure to represent an allocated object */
typedef struct meta_obj meta_obj_type;
typedef struct meta_root meta_root_type;

/* used for type definitions */
typedef struct meta_obj_def meta_obj_def_type;
typedef struct meta_obj_ptr_def meta_obj_ptr_def_type;

/* used by the GC to mark cells */
typedef enum mark {
    LIVE,
    FORWARDING,
    FIXED       /* Pinned object -- do not copy or forward */
} mark_type;

/* are we looking at a pointer or an array */
typedef enum meta_ptr { PTR, ARRAY } meta_ptr_type;

/* meta object wrapper */
struct meta_obj {
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
    uint8_t *memory_pool; /* pointer to the root of the available memory pool */
    uint8_t *memory_pool_head; /* pointer to the next available memory region */
    vm_int pool_size; /* size of the current memory pool */

    uint8_t *old_pool; /* previous pool kept alive for stale C pointers */

    bool sweeping; /* detect re-entrant sweep. (i.e. no memory left) */
    
    meta_root_type *root_list; /* list of root pointers */
    meta_root_type *pruned_root_list; /* list of previous pointers */

    meta_obj_def_type *type_defs; /* definitions of various types */
    uint32_t num_types;           /* number of types */

    vm_int protect_count;

    vm_int allocations; /* Total number of active allocations */
    vm_int free; /* Tracking when to do a GC run */
    vm_int sweeps; /* Count of the number of sweeps since app start. */

    gc_type_def array_type; /* typedef for pointer arrays */

    bool validate; /* when true, copy_graph validates pointer pool membership */

    /* Set during sweep for validation: boundaries of the from-space and to-space */
    uint8_t *from_space;
    uint8_t *from_space_end;
    uint8_t *to_space;
    uint8_t *to_space_end;
} gc_ms_type;

/* do the actual object allocation */
meta_obj_type *internal_alloc(gc_ms_type *gc, size_t size);

/* clean up an allocated list of objects */
void destroy_types(gc_ms_type *gc, meta_obj_def_type *type_list, uint32_t num_types);

/* mark a list of root objects */
void copy_root(gc_ms_type *gc, meta_root_type *list);
void sweep(gc_ms_type *gc);

/* used to convert between objects and meta objects */
#define meta_from_obj(obj_ptr) (!obj_ptr ? 0 : (meta_obj_type *)(((uint8_t *)obj_ptr) - offsetof(meta_obj_type, obj)))
#define obj_from_meta(meta) (!meta ? 0 : &(meta->obj))

void *gc_malloc(gc_ms_type *gc, size_t size);
void gc_free(gc_ms_type *gc, void *obj);

/* Offeset into a meta object for the actual object */
#define OBJECT_OFFSET offsetof(meta_obj_type, obj)

/* Deal with these as a macro in case I need to change them latter. */
#define MALLOC(size) calloc(size, 1)
#define MALLOC_TYPE(type) (type *)MALLOC(sizeof(type))
#define FREE(ptr) free(ptr)

#endif
