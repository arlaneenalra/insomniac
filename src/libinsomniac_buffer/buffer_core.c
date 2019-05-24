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
void buffer_create(gc_type *gc, buffer_type **buf_ret) {
    static uint8_t init = 0;
    static gc_type_def buffer_gc_type = 0;
    static gc_type_def block_gc_type = 0;

    buffer_internal_type *buf = 0;

    gc_protect(gc);

    /* make sure types are registered */
    if (!init) {
        buffer_gc_type = create_buffer_type(gc);
        block_gc_type = create_block_type(gc);
    }

    /* allocate a new buffer object */
    gc_alloc_type(gc, 0, buffer_gc_type, (void **)&buf);

    buf->block_gc_type = block_gc_type;
    buf->gc = gc;

    /* allocate our first block */
    /* buf->head = buf->tail = gc_alloc_type(buf->gc, 0, buf->block_gc_type); */
    gc_alloc_type(buf->gc, 0, buf->block_gc_type, (void **)&(buf->tail));
    buf->head = buf->tail;

    /* save our buffer in the passed in pointer */
    *buf_ret = buf;

    gc_unprotect(gc);
}

/* Empty the given buffer and free space allocated to it. */
void buffer_reset(buffer_type *buf_void) {
    buffer_internal_type *buf = (buffer_internal_type *)buf_void;

    /* Empty contents of buffer */
    buf->used = 0;

    /* Buffers always have at least one allocated block */
    buf->head = buf->tail;
    buf->head->next = 0;
}

/* allocate a new buffer block and place it at the head of the list */
void buffer_push(buffer_internal_type *buf) {
    block_type *new_tail = 0;

    gc_protect(buf->gc);

    gc_alloc_type(buf->gc, 0, buf->block_gc_type, (void **)&new_tail);

    buf->tail->next = new_tail;
    buf->tail = new_tail;

    gc_unprotect(buf->gc);
}

/* write data into the given buffer */
void buffer_write(buffer_type *buf_void, uint8_t *bytes, size_t length) {
    buffer_internal_type *buf = (buffer_internal_type *)buf_void;
    size_t write_offset = (buf->used % BLOCK_SIZE);
    int block_remaining = BLOCK_SIZE - write_offset;
    size_t offset = 0;

    /* make sure that we have a block allocated */
    if (!block_remaining) {
        buffer_push(buf);
    }

    /* deal with data of less than block size */
    if (length < block_remaining) {
        block_remaining = length;
    }

    /* Copy data into individual blocks */
    while (length > 0) {

        /* copy data to from our passed in value array to the buffer */
        memcpy(&(buf->tail->block[write_offset]), &(bytes[offset]), block_remaining);

        /* update write location and count down
           length */
        offset += block_remaining;
        buf->used += block_remaining;

        length -= block_remaining;

        /* Do we need another block? */
        if (!(buf->used % BLOCK_SIZE)) {
            write_offset = 0;
            buffer_push(buf);
        }

        /* do we have more than a block left ? */
        if (length >= BLOCK_SIZE) {
            block_remaining = BLOCK_SIZE;
        } else {
            block_remaining = length;
        }
    }
}

/* read data out of the given buffer */
size_t buffer_read(buffer_type *buf_void, uint8_t *dest_ptr, size_t length) {
    buffer_internal_type *buf = (buffer_internal_type *)buf_void;
    uint8_t *dest = dest_ptr;
    block_type *block = 0;
    size_t offset = 0;
    size_t copy_amount = 0;

    block = buf->head;

    /* walk all blocks and copy them into the destination buffer */
    while ((block != 0) && (offset < length)) {

        /* do we have a whole block or a partial one */
        copy_amount = length - offset;

        /* only copy a block at a time */
        if (copy_amount >= BLOCK_SIZE) {
            copy_amount = BLOCK_SIZE;
        }

        /* copy data from block to destination */
        memcpy(&(dest[offset]), &(block->block[0]), copy_amount);

        offset += copy_amount;

        /* move to next block */
        block = block->next;
    }

    return offset;
}

/* read data out of the given buffer */
size_t buffer_append(buffer_type *buf_void, buffer_type *src_void, size_t length) {
    buffer_internal_type *buf = (buffer_internal_type *)src_void;
    block_type *block = 0;
    size_t offset = 0;
    size_t copy_amount = 0;

    block = buf->head;

    /* if size is set to -1, then look it via buffer_size */
    if (length == -1) {
        length = buffer_size(src_void);
    }

    /* walk all blocks and copy them into the destination buffer */
    while ((block != 0) && (offset < length)) {

        /* do we have a whole block or a partial one */
        copy_amount = length - offset;

        /* only copy a block at a time */
        if (copy_amount >= BLOCK_SIZE) {
            copy_amount = BLOCK_SIZE;
        }

        /* copy data from block to destination */
        buffer_write(buf_void, block->block, copy_amount);

        offset += copy_amount;

        /* move to next block */
        block = block->next;
    }

    return offset;
}

/* return the size of the buffer */
size_t buffer_size(buffer_type *buf_void) {
    buffer_internal_type *buf = (buffer_internal_type *)buf_void;
    return buf->used;
}


