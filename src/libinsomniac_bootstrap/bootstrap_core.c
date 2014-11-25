#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#include <errno.h>
#include <assert.h>


/* Make a label */
void gen_label(compiler_core_type *compiler, buffer_type **buf) {
    char c[22];
    int written = 0;

    buffer_create(compiler->gc, buf);
    buffer_write(*buf, (uint8_t *)"_label_", 7);

    /* Add an incrementing suffix to the label */
    written = snprintf(c, 22, "%"PRIi64, compiler->label_index);
    buffer_write(*buf, (uint8_t *)c, written); 
    
    compiler->label_index++;
}

/* Setup Include */
/* Pushes a new file into the lexer's input stream while preserving
 * the existing stream. */
void setup_include(compiler_core_type* compiler,
  buffer_type *buf, buffer_type *file) {
    char *include_comment = "Included From:";
    FILE *include_file = 0;
    char *file_name = 0;
    size_t length = 0;
    
    gc_register_root(compiler->gc, (void **)&file_name);

    /* Extract parsed filename */
    length = buffer_size(file);
    gc_alloc(compiler->gc, 0, length, (void **)&file_name);
    length = buffer_read(file, (uint8_t *)file_name, length);

    //buffer_write(buf, (uint8_t *)include_comment, strlen(include_comment));
    //buffer_write(buf, (uint8_t *)file_name, length);
    //emit_newline(buf);
    emit_comment(buf, include_comment);
    emit_comment(buf, file_name);
 
    include_file = fopen(file_name, "r");

    if ( !include_file ) {
        // TODO: Add file name tracking to compiler so we can 
        // report what file include failed in.
       
        (void)fprintf(stderr, "Error %i!", errno);
        parse_error(compiler, compiler->scanner,
          "Unable to open include file!");
    } else {
        parse_push_state(compiler, include_file);
    }
       
    gc_unregister_root(compiler->gc, (void **)&file_name);
}

/* Interface into the compiler internals */
// TODO: Make compiler code work like the other libraries
size_t compile_string(gc_type *gc, char *str, char **asm_ref) {
    //yyscan_t scanner =0;
    size_t length = 0;
    compiler_core_type compiler;
    buffer_type *buf = 0;

    gc_register_root(gc, (void **)&buf);
    gc_register_root(gc, (void **)&compiler.tree);

    compiler.gc = gc;
    compiler.label_index = 0;
    compiler.preamble = "lib/preamble.asm";
    compiler.postamble = "lib/postamble.asm";

    buffer_create(gc, &buf);

    /* Actually parse the input stream. */
    yylex_init(&compiler.scanner);
    yy_scan_string(str, compiler.scanner);

    /* TODO: Need a better way to handle GC than leaking */
    gc_protect(compiler.gc);
    
    parse_internal(&compiler, compiler.scanner);
    
    gc_protect(compiler.gc);

    yylex_destroy(compiler.scanner);

    /* Add appropriate bootstraping code */
    emit_bootstrap(&compiler, buf);

    /* Convert the output buffer back to a string. */
    length = buffer_size(buf);
    gc_alloc(gc, 0, length, (void **)asm_ref);
    length = buffer_read(buf, (uint8_t *)*asm_ref, length);
    
    gc_unregister_root(gc, (void **)&compiler.tree);
    gc_unregister_root(gc, (void **)&buf);

    return length;
}

