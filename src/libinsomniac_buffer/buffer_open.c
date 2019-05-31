#include "buffer_internal.h"

#ifdef __APPLE__

/* Convert buffer_write into the correct signature. */
int buffer_write_wrapper(void *buf, const char *c, int size) {
    
    buffer_write((buffer_type *)buf, (uint8_t *)c, size);

    return size;
}

/* Open a buffer object as a FILE. */
FILE *buffer_open(buffer_type *buf) {
    return funopen(buf, 0, &buffer_write_wrapper, 0, 0);
}

#elif __linux__

/* Convert buffer_write into the correct signature. */
ssize_t buffer_write_wrapper(void *buf, const char *c, size_t size) {
    buffer_write((buffer_type *)buf, (uint8_t *)c, size);

    return size;
}

/* Open a buffer object as a FILE. */
FILE *buffer_open(buffer_type *buf) {
    cookie_io_functions_t buffer_func = {
        .read = 0,
        .write = buffer_write_wrapper,
        .seek = 0,
        .close = 0 
    };

    return fopencookie(buf, "w", buffer_func);
}

#endif
