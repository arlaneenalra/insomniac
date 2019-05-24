
#include <assert.h>
#include <errno.h>
#include <stdio.h>

#include <fcntl.h>
#include <libgen.h>
#include <limits.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <insomniac.h>

#include <asm.h>

#include <bootstrap.h>

#include <locale.h>

#ifdef __APPLE__
char *target_preamble = "    .section __TEXT,__text\n"
                        "    .global _main\n"
                        "    .p2align 4, 0x90\n"
                        "_main:\n"
                        "   .cfi_startproc\n"
                        "    pushq  %rbp\n"
                        "    .cfi_def_cfa_offset 16\n"
                        "    .cfi_offset %rbp, -16\n"
                        "    movq   %rsp, %rbp\n"
                        "    .cfi_def_cfa_register %rbp\n"
                        "    xorl   %eax, %eax\n"
                        "    call _run_scheme\n"
                        "    popq   %rbp\n"
                        "    retq\n"
                        "   .cfi_endproc\n"
                        ".global _scheme_code\n"
                        "_scheme_code:\n"
                        "    leaq str(%rip), %rax\n"
                        "    retq\n"
                        ".global _scheme_code_size\n"
                        "_scheme_code_size:\n"
                        "   leaq str_size(%rip), %rax\n"
                        "   movq (%rax), %rax\n"
                        "   retq\n"
                        ".section __DATA,_data\n"
                        "meta:\n"
                        "   .quad 0 # meta_obj.next\n"
                        "   .long 0 # meta_obj.mark\n"
                        "   .long 0 # meta_obj.size\n"
                        "   .long 0 # meta_obj.type_def\n"
                        "str:\n";

char *target_size = "\n"
                    "str_size :\n"
                    "   .quad ";

char *target_postamble = "\n";

#elif __linux__
char *target_preamble = "   .text\n"
                        "   .globl main\n"
                        "main:\n"
                        "   pushq %rbp\n"
                        "   movq %rsp, %rbp\n"
                        "   call run_scheme@PLT\n"
                        "   popq %rbp\n"
                        "   ret\n"
                        ".globl scheme_code\n"
                        "scheme_code:\n"
                        "    leaq str(%rip), %rax\n"
                        "    retq\n"
                        ".globl scheme_code_size\n"
                        "scheme_code_size:\n"
                        "   leaq str_size(%rip), %rax\n"
                        "   movq (%rax), %rax\n"
                        "   retq\n"
                        "   .data\n"
                        "meta:\n"
                        "   .quad 0 # meta_obj.next\n"
                        "   .long 0 # meta_obj.mark\n"
                        "   .long 0 # meta_obj.size\n"
                        "   .long 0 # meta_obj.type_def\n"
                        "str:\n";

char *target_size = "\n"
                    "str_size :\n"
                    "   .quad ";

char *target_postamble = "\n";
#endif

typedef struct options options_type;

struct options {
    char *exe;
    char *filename;
    char *outfile;
    bool pre_post_amble;
    bool include_baselib;
    bool assemble;
    bool debug;
};

void usage(options_type *opts) {
    fprintf(
        stderr,
        "Usage: %s [--no-pre] [--no-baselib] [--no-assemble] [--debug] <file.scm> "
        "<out.asm>\n",
        opts->exe);
    exit(-1);
}

/* A very crude cli options parser */
void parse_options(int argc, char **argv, options_type *opts) {
    int i = 1;
    char *arg = 0;

    opts->exe = argv[0];

    /* check for file argument */
    if (argc < 2 || argc > 5) {
        usage(opts);
    }

    while (i < argc) {
        arg = argv[i];

        if (strcmp(arg, "--no-pre") == 0) {
            opts->pre_post_amble = false;
        } else if (strcmp(arg, "--no-baselib") == 0) {
            opts->include_baselib = false;
        } else if (strcmp(arg, "--no-assemble") == 0) {
            opts->assemble = false;
        } else if (strcmp(arg, "--no-debug") == 0) {
            opts->debug = false;
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

/* Write an indexed label to a buffer */
void writeLabel(buffer_type *buf, char *prefix, int idx) {
    char c[22];
    int written = 0;

    buffer_write(buf, (uint8_t *)prefix, strlen(prefix));

    written = snprintf(c, 22, "%i", idx);
    buffer_write(buf, (uint8_t *)c, written);
}

/* Write the assembly output to a file */
void writeToFile(options_type *opts, char *asm_str, size_t length) {
    FILE *out = 0;
    size_t wrote = 0;
    int err = 0;

    /* if not output file is given, write directly to output. */
    if (!opts->outfile) {
        out = stdout;
    } else {
        out = fopen(opts->outfile, "w");
    }

    if (!out) {
        (void)fprintf(
            stderr, "Error %i while opening output file '%s'\n", errno, opts->outfile);
        assert(0);
    }

    wrote = fwrite(asm_str, 1, length, out);

    if (wrote != length || (err = ferror(out))) {
        (void)fprintf(
            stderr,
            "Error %i while writing to output file '%s' Wrote: %zu "
            "Expected to Write: %zu\n",
            err, opts->outfile, wrote, length);
        assert(0);
    }

    fclose(out);
}

size_t buildAttachment(gc_type *gc, char *asm_str, char **target) {
    uint8_t *code_ref = 0;
    buffer_type *target_buf = 0;
    FILE *out_buffer = 0;
    debug_info_type *debug = 0;
    size_t length = 0;
    char *line_prefix = "\n    .byte ";

    gc_register_root(gc, (void **)&code_ref);
    gc_register_root(gc, (void **)&target_buf);
    gc_register_root(gc, (void **)&debug);

    length = asm_string(gc, asm_str, &code_ref, &debug);

    buffer_create(gc, &target_buf);
    out_buffer = buffer_open(target_buf);
    
    (void)fputs(target_preamble, out_buffer);
    (void)fputs(line_prefix, out_buffer);

    for (size_t i = 0; i < length; i++) {
        (void)fprintf(out_buffer, "%i", code_ref[i]);

        /* Don't add a , on the last value. */
        if (i + 1 < length) {
            /* make sure our lines aren't too long. */
            if (i % 50 == 0 && i > 0) {
                (void)fputs(line_prefix, out_buffer);
            } else {
                (void)fputs(", ", out_buffer);
            }
        }
    }

    (void)fputs(target_size, out_buffer);

    /* Output the size */
    (void)fprintf(out_buffer, "%zu", length - 1);

    (void)fputs(target_postamble, out_buffer);
    (void)fclose(out_buffer);

    /* Convert the buffer to a string */
    length = buffer_size(target_buf) + 1;
    gc_alloc(gc, 0, length, (void **)target);
    length = buffer_read(target_buf, *(uint8_t **)target, length);
    
    gc_unregister_root(gc, (void **)&debug);
    gc_unregister_root(gc, (void **)&target_buf);
    gc_unregister_root(gc, (void **)&code_ref);

    return length;
}

int main(int argc, char **argv) {
    options_type opts = {0, 0, 0, true, true, true, true};
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

    /* Assemble byte code. */
    if (opts.assemble) {
        length = buildAttachment(gc, asm_str, &asm_str);
    }

    /* Write the assembled code out to a file *without the null* at the end of
     * the string. */
    writeToFile(&opts, asm_str, length - 1);

    /* Clean up the garabge collector */
    gc_unregister_root(gc, (void **)&compiler);
    gc_unregister_root(gc, (void **)&asm_buf);
    gc_unregister_root(gc, (void **)&asm_str);
    gc_destroy(gc);

    return 0;
}
