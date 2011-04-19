#ifndef _CELL_
#define _CELL_

#include <inttypes.h>

typedef int64_t vm_int;

typedef enum mark {
    RED,
    BLACK,
    
    PERM
} mark_type;

typedef struct object object_type;

/* specifies what kind of data is in the current object */
typedef enum cell {
    FIXNUM,
    PAIR,
    
    EMPTY
} cell_type;

/* a pair of objects */
typedef struct pair {
    object_type *car;
    object_type *cdr;
} pair_type;


/* define a memory object */
struct object {
    cell_type type;
    
    /* what is actually stored in this
       memory location */
    union {
        vm_int integer;
        pair_type pair;
    } value;

    mark_type mark;
};


#endif
