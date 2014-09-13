
#include <stdio.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <insomniac.h>

#include <bootstrap.h>

#include <locale.h>

void load_buf(gc_type *gc, char *file, char **code_str) {
    int fd = 0;
    char bytes[4096];
    size_t count = 0;
    buffer_type *buf = 0;

    gc_register_root(gc, &buf);
    buffer_create(gc, (void **)&buf);

    fd = open(file, O_RDONLY);

    /* make sure that we could open the file */
    if(fd == -1 ) {
        printf("Unable to open input file: %s\n", file);
        exit(-2);
    }
    
    /* read everything into our elastic buffer */
    while((count = read(fd, bytes, BLOCK_SIZE))) {
        buffer_write(buf, (uint8_t *)bytes, count);
    }

    close(fd);

    /* Convert to a single string */
    count = buffer_size(buf);
    gc_alloc(gc, 0, count, (void **)code_str);

    buffer_read(buf, (uint8_t *)*code_str, count);

    gc_unregister_root(gc, &buf);
}


int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    char *code_str = 0;
    char *asm_str = 0;
    size_t code_size = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");

    /* check for file argument */
    if(argc < 2) {
        printf("Usage: %s <file.scm>\n", argv[0]);
        exit(-1);
    }

    /* make this a root to the garbage collector */
    gc_register_root(gc, (void **)&code_str);
    gc_register_root(gc, (void **)&asm_str);

    /* load and eval */
    load_buf(gc, argv[1], &code_str);
    code_size = compile_string(gc, code_str, &asm_str);
    
    printf("%s", asm_str);

    // Clean up the garabge collector
    gc_unregister_root(gc, (void **)&asm_str);
    gc_unregister_root(gc, (void **)&code_str);
    gc_destroy(gc);

    return 0;
}
