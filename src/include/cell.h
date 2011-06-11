#ifndef _CELL_
#define _CELL_

#include <inttypes.h>

typedef int64_t vm_int;
typedef uint8_t vm_bool;
typedef uint32_t vm_char;

typedef struct object object_type;

/* specifies what kind of data is in the current object */
typedef enum cell {
    FIXNUM,
    BOOL,
    CHAR,

    PAIR,
    
    EMPTY,

    CELL_MAX /* Hack to get last enum value */
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
        vm_bool bool;
        vm_char character;
    } value;

};

#endif
