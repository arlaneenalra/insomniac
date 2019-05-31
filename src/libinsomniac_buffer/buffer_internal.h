#ifndef _BUFFER_INTERNAL_
#define _BUFFER_INTERNAL_

#include <gc.h>

#include <buffer.h>
#include <stddef.h>

typedef struct block block_type;

/* a single block in our buffer definition */
struct block {
    uint8_t block[BLOCK_SIZE];
    block_type *next;
};

/* wrapper object for a buffer */
typedef struct buffer {
    /* garbage collector that created this buffer */
    gc_type *gc;

    /* pointers to head and tail of buffer linked list */
    block_type *head;
    block_type *tail;

    /* amount of space used in the current block */
    size_t used;

    /* Hack to make sure we have access to block type */
    gc_type_def block_gc_type;
} buffer_internal_type;

#endif
