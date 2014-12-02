
#include <stdio.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#include <insomniac.h>

#include <bootstrap.h>

#include <locale.h>

typedef struct options options_type;

struct options {
  char *exe;
  char *filename;
  bool pre_post_amble;
  bool include_baselib;
};

void usage(options_type *opts) {
    fprintf(stderr, "Usage: %s [--no-pre] [--no-baselib] <file.scm>\n", opts->exe);
    exit(-1);
}

/* A very crude cli options parser */
void parse_options (int argc, char **argv, options_type *opts) {
    int i = 1;
    char *arg = 0;

    opts->exe = argv[0];

    /* check for file argument */
    if (argc < 2 || argc > 3) {
       usage(opts);
    }

    while (i < argc) {
        arg = argv[i];

        if (strcmp(arg, "--no-pre") == 0 ) {
          opts->pre_post_amble = false;
        } else if(strcmp(arg, "--no-baselib") == 0 ) {
          opts->include_baselib = false;
        } else {
          opts->filename = arg;
        }

        i++;
    }

    if (opts->filename == 0) {
       usage(opts);
    }
}

int main(int argc, char**argv) {
    options_type opts = { 0, 0, true, true };
    gc_type *gc = gc_create(sizeof(object_type));
    size_t length = 0;
    char *code_str = 0;
    char *asm_str = 0;
    compiler_type *compiler = 0;
    buffer_type *asm_buf = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");

    parse_options(argc, argv, &opts);

    /* make this a root to the garbage collector */
    gc_register_root(gc, (void **)&code_str);
    gc_register_root(gc, (void **)&asm_str);
    gc_register_root(gc, (void **)&asm_buf);
    gc_register_root(gc, (void **)&compiler);

    compiler_create(gc, &compiler);

    /* load and compiler */
    (void)buffer_load_string(gc, opts.filename, &code_str);
    compile_string(compiler, code_str, opts.include_baselib);

    /* Generate code */
    buffer_create(gc, &asm_buf);

    compiler_code_gen(compiler, asm_buf, opts.pre_post_amble);
   
    /* Convert generated code to string */
    length = buffer_size(asm_buf);
    gc_alloc(gc, 0, length, (void **)&asm_str);
    length = buffer_read(asm_buf, (uint8_t *)asm_str, length); 

    printf("%s", asm_str);

    // Clean up the garabge collector
    gc_unregister_root(gc, (void **)&compiler);
    gc_unregister_root(gc, (void **)&asm_buf);
    gc_unregister_root(gc, (void **)&asm_str);
    gc_unregister_root(gc, (void **)&code_str);
    gc_destroy(gc);

    return 0;
}
