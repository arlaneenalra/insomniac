
#include <stdio.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <insomniac.h>

#include <bootstrap.h>

#include <locale.h>

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
    (void)buffer_load_string(gc, argv[1], &code_str);
    code_size = compile_string(gc, code_str, &asm_str);
    
    printf("%s", asm_str);

    // Clean up the garabge collector
    gc_unregister_root(gc, (void **)&asm_str);
    gc_unregister_root(gc, (void **)&code_str);
    gc_destroy(gc);

    return 0;
}
