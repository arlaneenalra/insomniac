#include "buffer_internal.h"
#include <string.h>

gc_type_def create_buffer_type(gc_type *gc) {
    gc_type_def type = 0;

    type = gc_register_type(gc, sizeof(buffer_internal_type));
    gc_register_pointer(gc, type, offsetof(buffer_internal_type, head));
    return type;
}

gc_type_def create_block_type(gc_type *gc) {
    gc_type_def type = 0;

    type = gc_register_type(gc, sizeof(block_type));
    gc_register_pointer(gc, type, offsetof(block_type, next));
    return type;    
}

/* create a new buffer */
buffer_type *buffer_create(gc_type *gc) {
    static uint8_t init = 0;
    static gc_type_def buffer_gc_type = 0;
    static gc_type_def block_gc_type = 0;

    buffer_internal_type * buf = 0;

    /* make sure types are registered */
    if(!init) {
        buffer_gc_type = create_buffer_type(gc);
        block_gc_type = create_block_type(gc);
    }

    /* allocate a new buffer object */
    buf = gc_alloc_type(gc, 0, buffer_gc_type);
    
    buf->block_gc_type = block_gc_type;
    buf->gc = gc;

    return buf;
}

/* allocate a new buffer block and place it at the head of the list */
void buffer_push(buffer_internal_type *buf) {
    block_type *old_head = 0;
    
    old_head = buf->head;
    buf->head = gc_alloc_type(buf->gc, 0, buf->block_gc_type);
    buf->head->next = old_head;
    
    buf->used = 0;
}

/* write data into the given buffer */
void buffer_write(buffer_type *buf_void, uint8_t *bytes, size_t length) {
    buffer_internal_type *buf=(buffer_internal_type *)buf_void;
    int remaining = BLOCK_SIZE; /* our buffers should never be big enough 
                                   for the size of int to matter */

    /* make sure that we have a block allocated */
    if(!buf->head) {
        buffer_push(buf);
    }

    /* check to see if we need a new block due to data used */
    remaining = remaining - buf->used;
    
    if(remaining - length >=0) {
        
        /* we still have room in this block, 
           so memcopy and add the length */
        memcpy(&(buf->head->block[buf->used]),
               bytes,length);
        buf->used+=length;
    } else {
        /* we need to split the data we were given 
           first, copy what we can into the current block
         */
        memcpy(&(buf->head->block[buf->used]),
               bytes,remaining);

        /* adjust what remains and pointer */
        length-=remaining; 
        bytes+=remaining;
        
        buffer_push(buf);
        memcpy(&(buf->head->block[buf->used]),
               bytes,length);
    }
}

/* read data out of the given buffer */
size_t buffer_read(buffer_type *buf_void, uint8_t **dest, size_t length) {
    buffer_internal_type *buf=(buffer_internal_type *)buf_void;
    /* TODO! */
    return 0;
}

