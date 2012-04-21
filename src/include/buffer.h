#ifndef _BUFFER_
#define _BUFFER_

#define BLOCK_SIZE 4096

/* Basic data types and functions for an elastic buffer */
typedef void buffer_type;

/* create a new buffer */
void buffer_create(gc_type *gc, buffer_type **buf_ret);

/* write bytes into the buffer */
void buffer_write(buffer_type *buf, uint8_t * bytes, size_t length);

/* return the number of bytes in a buffer */
size_t buffer_size(buffer_type *buf);

/* create a new buffer of size_t bytes containing everything 
 in the buffer. */
size_t buffer_read(buffer_type *buf, uint8_t *dest, size_t length);


#endif
