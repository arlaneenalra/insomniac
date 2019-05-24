#include "buffer_internal.h"

/* Convert buffer_write into the correct format. */
int buffer_write_wrapper(void *buf, const char *c, int size) {
    
    buffer_write((buffer_type *)buf, (uint8_t *)c, size);

    return size;
}

/* open a buffer object as a FILE */
FILE *buffer_open(buffer_type *buf) {
    return funopen(buf, 0, &buffer_write_wrapper, 0, 0);
}

