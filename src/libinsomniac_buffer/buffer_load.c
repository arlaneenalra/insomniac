#include "buffer_internal.h"

#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

/* slurp a file into a buffer */
size_t buffer_load(buffer_type *buf, char *file) {
    int fd = 0;
    char bytes[BLOCK_SIZE];
    size_t count = 0;
    size_t loaded = 0;

    fd = open(file, O_RDONLY);

    /* make sure that we could open the file */
    if (fd == -1) {
        return -1;
    }

    /* read everything into our elastic buffer */
    while ((count = read(fd, bytes, BLOCK_SIZE))) {
        buffer_write(buf, (uint8_t *)bytes, count);
        loaded += count;
    }

    close(fd);

    return loaded;
}

/* Use our buffer library to slurp a file into a string */
size_t buffer_load_string(gc_type *gc, char *file, char **str) {
    size_t count = 0;
    buffer_type *buf = 0;

    gc_register_root(gc, &buf);
    buffer_create(gc, (void **)&buf);

    /* Convert to a single string */
    count = buffer_load(buf, file);

    /* Make sure we could read the file */
    if (count == -1) {
        printf("Unable to load file: %s\n", file);
        exit(-2);
    }

    gc_alloc(gc, 0, count + 1, (void **)str);

    buffer_read(buf, (uint8_t *)*str, count);

    gc_unregister_root(gc, &buf);

    return count;
}
