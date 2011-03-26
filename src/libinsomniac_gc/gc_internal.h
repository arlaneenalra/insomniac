#ifndef _GC_INTERNAL_
#define _GC_INTERNAL_

#include <stdlib.h>
#include <assert.h>

#include <gc.h>

/* An internal GC structure to represent an allocated object */
typedef struct meta_obj meta_obj_type;

struct meta_obj {
    object_type *obj; /* contained object */
    
    meta_obj_type *next; /* next object in our list */
};

/* the internal type used by the GC to keep track of things */
typedef struct gc_ms {

    meta_obj_type *active_list; /* list of reachable objects */
    meta_obj_type *dead_list; /* list of unreachable objects */

} gc_ms_type;

/* deal with these as a macro incase I need to change them latter */
#define MALLOC(type) (type *)calloc(1, sizeof(type));
#define FREE(ptr) free(ptr);


/* do the actual object allocation */
object_type *internal_alloc(cell_type type);

/* clean up an allocated list of objects */
void destroy_list(meta_obj_type **list);

#endif
