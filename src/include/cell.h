#ifndef _CELL_
#define _CELL_

#include <inttypes.h>

typedef int64_t vm_int;

/* define a cell */
typedef union cell {
    vm_int int_val;
} cell_type;


#endif
