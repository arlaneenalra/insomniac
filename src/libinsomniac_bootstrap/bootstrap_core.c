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

/* Setup gc types */

/* Instruction Stream type setup */
gc_type_def register_stream_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(ins_stream_type));
  /* we only need to register the head */
  gc_register_pointer(gc, type, offsetof(ins_stream_type, head));

  return type;
}

/* setup an literal node */
gc_type_def register_node_literal_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(ins_node_type));
  gc_register_pointer(gc, type, offsetof(ins_node_type, next));
  gc_register_pointer(gc, type, offsetof(ins_node_type, value) +
    offsetof(node_value_type, literal));

  /* Add other fields here */

  return type;
}

/* setup an quoted/list node */
gc_type_def register_node_quoted_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(ins_node_type));
  gc_register_pointer(gc, type, offsetof(ins_node_type, next));
  gc_register_pointer(gc, type, offsetof(ins_node_type, value) +
    offsetof(node_value_type, stream));

  return type;
}

/* Instruction Stream type setup */
gc_type_def register_compiler_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(compiler_core_type));
  gc_register_pointer(gc, type, offsetof(compiler_core_type, stream));

  return type;
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

/* Create an instance of the compiler */
void compiler_create(gc_type *gc, compiler_type **comp_void) {
    compiler_core_type *compiler = 0;
    static gc_type_def stream_gc_type = 0;
    static gc_type_def node_literal_gc_type = 0;
    static gc_type_def node_quoted_gc_type = 0;
    static gc_type_def compiler_gc_type = 0;

    // setup gc types
    if (!compiler_gc_type) {
      compiler_gc_type = register_compiler_type(gc);
      stream_gc_type = register_stream_type(gc);
      node_literal_gc_type = register_node_literal_type(gc);
      node_quoted_gc_type = register_node_quoted_type(gc);
    }

    gc_register_root(gc, (void **)&compiler);

    /* create a compiler instance */
    gc_alloc_type(gc, 0, compiler_gc_type, (void **)&compiler);

    compiler->gc = gc;
    compiler->label_index = 0;
    compiler->preamble = "lib/preamble.asm";
    compiler->postamble = "lib/postamble.asm";

    /* setup gc types */
    compiler->stream_gc_type = stream_gc_type;

    compiler->node_types[STREAM_LITERAL] = node_literal_gc_type;
    compiler->node_types[STREAM_SYMBOL] = node_literal_gc_type;
    compiler->node_types[STREAM_QUOTED] = node_quoted_gc_type;

    *comp_void = compiler;

    /* Add a stream route to the compiler object */
    stream_create(compiler, &(compiler->stream));

    gc_unregister_root(gc, (void **)&compiler);
}

/* Interface into the compiler internals */
// TODO: Make compiler code work like the other libraries
void compile_string(compiler_type *comp_void, char *str) {
    compiler_core_type *compiler = (compiler_core_type *)comp_void; 

    /* Actually parse the input stream. */
    yylex_init(&(compiler->scanner));
    yy_scan_string(str, compiler->scanner);

    /* TODO: Need a better way to handle GC than leaking */
    gc_protect(compiler->gc);
    
    parse_internal(compiler, compiler->scanner);
    
    gc_unprotect(compiler->gc);

    yylex_destroy(compiler->scanner);
}

/* Convert an instruction stream into assembly */
void compiler_code_gen(compiler_type *comp_void, buffer_type * buf,
  bool bootstrap) {
    compiler_core_type *compiler = (compiler_core_type *)comp_void;

    /* Walk the instruction stream and output it to our buffer */
    emit_stream(buf, compiler->stream);

    /* Add appropriate bootstraping code */
    if (bootstrap) {
      /* TODO: Split bootstrap up into pre and post amble functions */
      emit_bootstrap(compiler, buf);
    }
}

