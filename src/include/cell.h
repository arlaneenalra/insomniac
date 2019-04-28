#ifndef _CELL_
#define _CELL_

#include <inttypes.h>
#include <stdbool.h>

typedef int64_t vm_int;
typedef uint32_t vm_char;

typedef struct object object_type;

/* specifies what kind of data is in the current object */
typedef enum cell {
    FIXNUM,
    BOOL,
    CHAR,

    STRING,
    SYMBOL,

    VECTOR,
    BYTE_VECTOR,
    RECORD,

    PAIR,
    EMPTY,

    CLOSURE,
    LIBRARY,

    CELL_MAX /* Hack to get last enum value */
} cell_type;

/* a pair of objects */
typedef struct pair {
    object_type *car;
    object_type *cdr;
} pair_type;

/* type used to store a string */
typedef struct string {
    vm_int length;
    char *bytes;
} string_type;

/* type to store a byte vector */
typedef struct byte_vector {
    vm_int length;
    uint8_t *vector;
    bool slice;
} byte_vector_type;

/* type to store a vector */
typedef struct vector {
    vm_int length;
    object_type **vector;
    bool slice;
} vector_type;

/* holds a portion of the vm's execution state */
typedef void * closure_type;

/* holds a library handle */
typedef struct library {
    void *handle;
    void *functions;
    vm_int func_count;
} library_type;

typedef union value {
    vm_int integer;
    pair_type pair;
    bool boolean;
    vm_char character;
    string_type string;
    vector_type vector;
    byte_vector_type byte_vector;
    closure_type closure;
    library_type library;
} value_type;

/* define a memory object */
struct object {
    cell_type type;

    /* what is actually stored in this
       memory location */
    value_type value;
};

#endif
