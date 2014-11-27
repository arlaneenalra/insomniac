#ifndef _BOOTSTRAP_INTERNAL
#define _BOOTSTRAP_INTERNAL

#include <gc.h>
#include <buffer.h>
#include <bootstrap.h>
#include <ops.h>
#include <stdio.h>

/* The different kinds of instruction nodes */
typedef enum node {
    STREAM_LITERAL,
    STREAM_SYMBOL,

    NODE_MAX
} node_type;

typedef union {
    char *literal;
} node_value_type;

/* An individual instructions */
typedef struct ins_node ins_node_type;

struct ins_node {
    node_type type;

    node_value_type value;

    /* Instructions are kept in a bi-directional linked-list to support
       back tracking in the optimizer */
    ins_node_type *next;
    ins_node_type *prev;
};

/* A stream of instructions */
typedef struct ins_stream ins_stream_type;

struct ins_stream {
    ins_node_type *head;
    ins_node_type *tail;
};

typedef struct compiler_core compiler_core_type;

struct compiler_core {
    gc_type *gc;

    /* internal types */
    gc_type_def stream_gc_type;
    gc_type_def node_types[NODE_MAX];



    /* path to preamble and postamble code */
    char *preamble;
    char *postamble;

    void *scanner;

    uint64_t label_index;

    /* The current instruction stream */
    ins_stream_type *stream;
};

void emit_bootstrap(compiler_core_type *compiler, buffer_type *buf);

void emit_stream(buffer_type *buf, ins_stream_type *tree);
void emit_literal(buffer_type *buf, ins_node_type *ins);

void emit_newline(buffer_type *buf);
void emit_indent(buffer_type *buf);
void emit_comment(buffer_type *buf, char *str);

void emit_op(buffer_type *buf, char *str);
void emit_jump_label(buffer_type *buf, op_type type, buffer_type *label);
void emit_char(buffer_type *buf, char *str);
void emit_fixnum(buffer_type *buf, char *str);
void emit_string(buffer_type *buf, buffer_type *str);
void emit_symbol(buffer_type *buf, char *str);
void emit_boolean(buffer_type *buf, int b);

void emit_if(compiler_core_type *compiler, buffer_type *test_buffer,
  buffer_type *true_buffer, buffer_type *false_buffer);

void emit_lambda(compiler_core_type *compiler, buffer_type *output,
  buffer_type *formals, buffer_type *body);
  
void gen_label(compiler_core_type *compiler, buffer_type **buf);

void setup_include(compiler_core_type* compiler,
  buffer_type *buf, buffer_type *file);

/* Instruction Stream builder routines */
void stream_create(compiler_core_type *compiler, ins_stream_type **stream);

void stream_concat(ins_stream_type *stream, ins_stream_type *source);
void stream_append(ins_stream_type *stream, ins_node_type *node);

void stream_boolean(compiler_core_type *compiler,
  ins_stream_type *stream, int b);
void stream_fixnum(compiler_core_type *compiler,
  ins_stream_type *stream, char *num);
void stream_string(compiler_core_type *compiler,
  ins_stream_type *stream, char *str);
void stream_symbol(compiler_core_type *compiler,
  ins_stream_type *stream, char *str);



/* Scheme parser */
int parse_internal(compiler_core_type *compiler, void *scanner);
void parse_error(compiler_core_type *compiler, void *scanner, char *s);

void parse_push_state(compiler_core_type *compiler, FILE *file);

/* Define some macros to make the parser code easier */
#define NEW_BUF(var) buffer_create(compiler->gc, &var)

#define EMIT(var, type, op) emit_##type(var, op)
#define EMIT_NEW(var, type, op) NEW_BUF(var); EMIT(var, type, op);

#define NEW_STREAM(var) stream_create(compiler, &var)

#define STREAM(var, type, op) stream_##type(compiler, var, op)
#define STREAM_NEW(var, type, op) NEW_STREAM(var); STREAM(var, type, op);

#endif
