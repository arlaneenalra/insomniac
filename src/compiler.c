
#include <stdio.h>
#include <assert.h>
#include <errno.h>

#include <limits.h>
#include <libgen.h>
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
  char *outfile;
  bool pre_post_amble;
  bool include_baselib;
};

void usage(options_type *opts) {
    fprintf(stderr, "Usage: %s [--no-pre] [--no-baselib] <file.scm> <out.asm>\n", opts->exe);
    exit(-1);
}

/* A very crude cli options parser */
void parse_options (int argc, char **argv, options_type *opts) {
    int i = 1;
    char *arg = 0;

    opts->exe = argv[0];

    /* check for file argument */
    if (argc < 2 || argc > 5) {
       usage(opts);
    }

    while (i < argc) {
        arg = argv[i];

        if (strcmp(arg, "--no-pre") == 0 ) {
          opts->pre_post_amble = false;
        } else if(strcmp(arg, "--no-baselib") == 0 ) {
          opts->include_baselib = false;
        } else {
          if (!opts->filename) {
            opts->filename = arg;
          } else {
            opts->outfile = arg;
          }
        }

        i++;
    }

    if (opts->filename == 0) {
       usage(opts);
    }
}

/* Write the assembly output to a file */
void writeToFile(char *outfile, char *asm_str, size_t length) {
  FILE *out = 0;
  size_t wrote = 0;
  int err = 0;

  out = fopen(outfile, "w");

  if (!out) {
    (void)fprintf(stderr, "Error %i while opening output file '%s'\n", errno, outfile);
    assert(0);
  }

  wrote = fwrite(asm_str, 1, length, out);

  if (wrote != length || (err = ferror(out))) {
    (void)fprintf(stderr,
      "Error %i while writing to output file '%s' Wrote: %zu Expected to Write: %zu\n",
      err, outfile, wrote, length);
    assert(0);
  }
  
  fclose(out);
}

int main(int argc, char**argv) {
    options_type opts = { 0, 0, 0, true, true };
    gc_type *gc = gc_create(sizeof(object_type));
    size_t length = 0;
    char *asm_str = 0;
    compiler_type *compiler = 0;
    buffer_type *asm_buf = 0;
    char realpath_buf[PATH_MAX];
    char compiler_home[PATH_MAX];


    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");

    parse_options(argc, argv, &opts);

    /* Attempt to get the default home of our compiler */
    strcpy(compiler_home, dirname(realpath(opts.exe, realpath_buf)));

    /* make this a root to the garbage collector */
    gc_register_root(gc, (void **)&asm_str);
    gc_register_root(gc, (void **)&asm_buf);
    gc_register_root(gc, (void **)&compiler);

    compiler_create(gc, &compiler, compiler_home);

    /* load and compiler */
    compile_file(compiler, opts.filename, opts.include_baselib);

    /* Generate code */
    buffer_create(gc, &asm_buf);

    compiler_code_gen(compiler, asm_buf, opts.pre_post_amble);
   
    /* Convert generated code to string */
    length = buffer_size(asm_buf);
    gc_alloc(gc, 0, length, (void **)&asm_str);
    length = buffer_read(asm_buf, (uint8_t *)asm_str, length); 

    if(!opts.outfile) {
      printf("%s", asm_str);
    } else {
      writeToFile(opts.outfile, asm_str, length);
    }

    // Clean up the garabge collector
    gc_unregister_root(gc, (void **)&compiler);
    gc_unregister_root(gc, (void **)&asm_buf);
    gc_unregister_root(gc, (void **)&asm_str);
    gc_destroy(gc);

    return 0;
}
