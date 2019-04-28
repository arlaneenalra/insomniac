#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#include <limits.h>
#include <stdlib.h>

#include <errno.h>
#include <assert.h>
#include <libgen.h>

/* Add an include path to the include stack */
void push_include_path(compiler_core_type *compiler, char *file_name) {
  
  compiler->include_depth++;
  
  gc_alloc(compiler->gc, 0, strlen(file_name) + 1,
    (void **)&(compiler->include_stack[compiler->include_depth]));

  strcpy(compiler->include_stack[compiler->include_depth], file_name);
}

/* Pop the current include path off the stack */
void pop_include_path(compiler_core_type *compiler) {
  
  /* null out this path so it can be garbage collected */
  if (compiler->include_depth >= 0) {
    compiler->include_stack[compiler->include_depth] = 0;
  }

  compiler->include_depth--;
}

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

/* Setup a literal node */
gc_type_def register_node_literal_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(ins_node_type));
  gc_register_pointer(gc, type, offsetof(ins_node_type, next));
  gc_register_pointer(gc, type, offsetof(ins_node_type, value) +
    offsetof(node_value_type, literal));

  /* Add other fields here */

  return type;
}

/* setup an single instruction stream node */
gc_type_def register_node_single_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(ins_node_type));
  gc_register_pointer(gc, type, offsetof(ins_node_type, next));
  gc_register_pointer(gc, type, offsetof(ins_node_type, value) +
    offsetof(node_value_type, stream));

  return type;
}

/* setup an two instruction stream node */ 
gc_type_def register_node_double_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(ins_node_type));
  gc_register_pointer(gc, type, offsetof(ins_node_type, next));

  gc_register_pointer(gc, type, offsetof(ins_node_type, value) +
    offsetof(node_value_type, two) + offsetof(two_stream_type, stream1));
  gc_register_pointer(gc, type, offsetof(ins_node_type, value) +
    offsetof(node_value_type, two) + offsetof(two_stream_type, stream2));

  return type;
}

/* Compiler core type  */
gc_type_def register_compiler_type(gc_type *gc) {
  gc_type_def type = 0;

  type = gc_register_type(gc, sizeof(compiler_core_type));
  gc_register_pointer(gc, type, offsetof(compiler_core_type, stream));
  gc_register_pointer(gc, type, offsetof(compiler_core_type, include_stack));

  return type;
}

/* Setup Include */
/* Pushes a new file into the lexer's input stream while preserving
 * the existing stream. */
void setup_include(compiler_core_type* compiler, ins_stream_type *arg) {

  FILE *include_file = 0;
  char *file_name = 0;
  char new_include_path_buf[PATH_MAX];
  char *new_include_path = 0;
  char new_file_name[PATH_MAX];
  char raw_file_name[PATH_MAX];
  size_t length = 0;

  /* Get the file name for this node */
  file_name = arg->head->value.literal;

  /* Unless the file starts with a / look for it in the current include directory */
  if (file_name[0] == '/' || compiler->include_depth < 0) {
    include_file = fopen(file_name, "r");
  } else {

    /* setup include path */
    strcpy(new_include_path_buf, compiler->include_stack[compiler->include_depth]);
    new_include_path = dirname(new_include_path_buf);
    
    /* add 1 for null and 1 for / */
    length = strlen(new_include_path) + strlen(file_name) + 2;

    if (length > PATH_MAX) {
      (void)fprintf(stderr, "Error %i! Including '%s' - Search path too long: %zi characters\n",
        errno, file_name, length);
      parse_error(compiler, compiler->scanner, "Unable to open include file!");
      assert(0);
    }
  
    /* Assmeble the new filename */
    strcpy(raw_file_name, new_include_path);
    strcat(raw_file_name, "/");
    strcat(raw_file_name, file_name);

    /* Resolve the path so it makes sense later */
    file_name = realpath(raw_file_name, new_file_name);

    include_file = fopen(file_name, "r");
  }

  if ( !include_file ) {
    // TODO: Add file name tracking to compiler so we can 
    // report what file include failed in.
   
    (void)fprintf(stderr, "Error %i! Including '%s'\n", errno, raw_file_name);
    parse_error(compiler, compiler->scanner, "Unable to open include file!'");
  } else {
    parse_push_state(compiler, include_file);
    push_include_path(compiler, file_name);
  }
}

/* Create an instance of the compiler */
void compiler_create(gc_type *gc, compiler_type **comp_void, char *compiler_home) {
  compiler_core_type *compiler = 0;
  static gc_type_def stream_gc_type = 0;
  static gc_type_def node_literal_gc_type = 0;
  static gc_type_def node_single_gc_type = 0;
  static gc_type_def node_double_gc_type = 0;
  static gc_type_def compiler_gc_type = 0;

  // setup gc types
  if (!compiler_gc_type) {
    compiler_gc_type = register_compiler_type(gc);
    stream_gc_type = register_stream_type(gc);
    node_literal_gc_type = register_node_literal_type(gc);
    node_single_gc_type = register_node_single_type(gc);
    node_double_gc_type = register_node_double_type(gc);
  }

  gc_register_root(gc, (void **)&compiler);

  /* create a compiler instance */
  gc_alloc_type(gc, 0, compiler_gc_type, (void **)&compiler);

  compiler->gc = gc;
  compiler->label_index = 0;
  /*compiler->preamble = "lib/preamble.asm";
  compiler->postamble = "lib/postamble.asm";*/
  strcpy(compiler->home, compiler_home);

  /* setup gc types */
  compiler->stream_gc_type = stream_gc_type;

  compiler->node_types[STREAM_LITERAL] = node_literal_gc_type;
  compiler->node_types[STREAM_SYMBOL] = node_literal_gc_type;
  compiler->node_types[STREAM_STRING] = node_literal_gc_type;
  compiler->node_types[STREAM_OP] = node_literal_gc_type;

  compiler->node_types[STREAM_QUOTED] = node_single_gc_type;
  compiler->node_types[STREAM_LOAD] = node_single_gc_type;
  compiler->node_types[STREAM_ASM] = node_single_gc_type;
  compiler->node_types[STREAM_ASM_STREAM] = node_single_gc_type;
  compiler->node_types[STREAM_COND] = node_single_gc_type;
  compiler->node_types[STREAM_AND] = node_single_gc_type;
  compiler->node_types[STREAM_OR] = node_single_gc_type;
  compiler->node_types[STREAM_RECORD_TYPE] = node_single_gc_type;

  compiler->node_types[STREAM_BIND] = node_double_gc_type;
  compiler->node_types[STREAM_STORE] = node_double_gc_type;

  compiler->node_types[STREAM_LET_STAR] = node_double_gc_type;
  
  compiler->node_types[STREAM_TWO_ARG] = node_double_gc_type;
  compiler->node_types[STREAM_IF] = node_double_gc_type;
  compiler->node_types[STREAM_MATH] = node_double_gc_type;
  
  compiler->node_types[STREAM_LAMBDA] = node_double_gc_type;
  compiler->node_types[STREAM_CALL] = node_double_gc_type;

  *comp_void = compiler;

  /* Add a stream route to the compiler object */
  stream_create(compiler, &(compiler->stream));

  /* Add the include stack array */
  // TODO: Look at statically allocating this 
  compiler->include_depth = -1;
  gc_alloc_pointer_array(gc, 0, MAX_INCLUDE_DEPTH, (void **)&(compiler->include_stack));

  gc_unregister_root(gc, (void **)&compiler);
}

/* Compile a string */
void compile_string(compiler_type *comp_void, char *str, bool include_baselib) {
  compiler_core_type *compiler = (compiler_core_type *)comp_void;
  ins_stream_type *baselib = 0; /* TODO: should be gc root */
  char path[PATH_MAX];

  /* Actually parse the input stream. */
  yylex_init_extra(compiler, &(compiler->scanner));
  yy_scan_string(str, compiler->scanner);

  /* TODO: Need a better way to handle GC than leaking */
  gc_protect(compiler->gc);

  /* Inject include for base library */
  if (include_baselib) {
    strcpy(path, compiler->home);
    strcat(path, "/lib/baselib.scm");

    STREAM_NEW(baselib, string, path);
    setup_include(compiler, baselib); 
  }
  
  parse_internal(compiler, compiler->scanner);
  
  gc_unprotect(compiler->gc);

  yylex_destroy(compiler->scanner);
}

/* Compile a file */
void compile_file(compiler_type *comp_void, char *file_name, bool include_baselib) {
  compiler_core_type *compiler = (compiler_core_type *)comp_void;
  ins_stream_type *baselib = 0; /* TODO: should be gc root */
  FILE *in = 0;
  char path[PATH_MAX];

  /* Actually parse the input stream. */
  yylex_init_extra(compiler, &(compiler->scanner));

  in = fopen(file_name, "r");
  if (!in) {
    (void)fprintf(stderr, "Error %i while attempting to open '%s'\n",
      errno, file_name);
      assert(0);
  }

  //yyset_in(in, compiler->scanner);
  yy_switch_to_buffer(
    yy_create_buffer(in, YY_BUF_SIZE, compiler->scanner), compiler->scanner);

  push_include_path(compiler, file_name);

  /* TODO: Need a better way to handle GC than leaking */
  gc_protect(compiler->gc);

  /* Inject include for base library */
  if (include_baselib) {
    strcpy(path, compiler->home);
    strcat(path, "/lib/baselib.scm");

    STREAM_NEW(baselib, string, path);
    setup_include(compiler, baselib); 
  }
  
  parse_internal(compiler, compiler->scanner);
  
  gc_unprotect(compiler->gc);

  yylex_destroy(compiler->scanner);
}

/* Convert an instruction stream into assembly */
void compiler_code_gen(compiler_type *comp_void, buffer_type * buf,
  bool bootstrap) {
  
  compiler_core_type *compiler = (compiler_core_type *)comp_void;

  /* Walk the instruction stream and output it to our buffer */
  emit_stream(compiler, buf, compiler->stream, false);

  /* Add appropriate bootstraping code */
  if (bootstrap) {
    /* TODO: Split bootstrap up into pre and post amble functions */
    emit_bootstrap(compiler, buf);
  }
}

