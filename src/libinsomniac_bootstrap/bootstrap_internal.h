#ifndef _BOOTSTRAP_INTERNAL
#define _BOOTSTRAP_INTERNAL

#include <gc.h>
#include <buffer.h>
#include <bootstrap.h>
#include <ops.h>
#include <stdio.h>

typedef struct ins_stream ins_stream_type;
typedef struct ins_node ins_node_type;
typedef struct compiler_core compiler_core_type;

/* The different kinds of instruction nodes */
typedef enum node {
    STREAM_LITERAL,
    STREAM_SYMBOL,
    STREAM_OP,
    
    STREAM_QUOTED,
    STREAM_ASM,
    STREAM_ASM_STREAM,
    
    STREAM_LOAD,

    STREAM_BIND,
    STREAM_STORE,

    STREAM_IF,

    NODE_MAX
} node_type;

typedef struct two_stream two_stream_type;

struct two_stream {
    ins_stream_type *stream1;
    ins_stream_type *stream2;
};

typedef union {
    char *literal;
    ins_stream_type *stream;
    two_stream_type two;
} node_value_type;

/* An individual instructions */

struct ins_node {
    node_type type;

    node_value_type value;

    /* Instructions are kept in a bi-directional linked-list to support
       back tracking in the optimizer */
    ins_node_type *next;
    ins_node_type *prev;
};

/* A stream of instructions */

struct ins_stream {
    ins_node_type *head;
    ins_node_type *tail;
};


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

void emit_stream(compiler_core_type *compiler, buffer_type *buf, ins_stream_type *tree);
void emit_literal(buffer_type *buf, ins_node_type *ins);
void emit_quoted(buffer_type *buf, ins_stream_type *tree);

void emit_asm(compiler_core_type *compiler, buffer_type *buf, ins_stream_type *tree);
void emit_double(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *node, char *op);
void emit_if(compiler_core_type *compiler, buffer_type *buf, ins_node_type *tree);

void emit_newline(buffer_type *buf);
void emit_indent(buffer_type *buf);
void emit_comment(buffer_type *buf, char *str);
void emit_label(buffer_type *buf, buffer_type *label);

void emit_op(buffer_type *buf, char *str);
void emit_jump_label(buffer_type *buf, op_type type, buffer_type *label);

void emit_lambda(compiler_core_type *compiler, buffer_type *output,
  buffer_type *formals, buffer_type *body);
  
void gen_label(compiler_core_type *compiler, buffer_type **buf);

void setup_include(compiler_core_type* compiler,
  buffer_type *buf, buffer_type *file);

/* Instruction Stream builder routines */
void stream_create(compiler_core_type *compiler, ins_stream_type **stream);

void stream_concat(ins_stream_type *stream, ins_stream_type *source);
void stream_append(ins_stream_type *stream, ins_node_type *node);

void stream_alloc_node(compiler_core_type *compiler, node_type type,
  ins_node_type **node);

#define BUILD_SINGLE_SIGNATURE(name) \
void stream_##name(compiler_core_type *compiler, ins_stream_type *stream, \
  ins_stream_type *arg1)

#define BUILD_DOUBLE_SIGNATURE(name) \
void stream_##name(compiler_core_type *compiler, ins_stream_type *stream, \
  ins_stream_type *arg1, ins_stream_type *arg2)

/* Nodes that hold a stream of instructions */
BUILD_SINGLE_SIGNATURE(asm);
BUILD_SINGLE_SIGNATURE(asm_stream);
BUILD_SINGLE_SIGNATURE(quoted);
BUILD_SINGLE_SIGNATURE(load);

/* Nodes that hold two streams */
BUILD_DOUBLE_SIGNATURE(bind);
BUILD_DOUBLE_SIGNATURE(store);

BUILD_DOUBLE_SIGNATURE(if);
BUILD_DOUBLE_SIGNATURE(if_body);

/* Special Literals */
void stream_boolean(compiler_core_type *compiler,
  ins_stream_type *stream, int b);
void stream_char(compiler_core_type *compiler,
  ins_stream_type *stream, char *str);

void stream_string(compiler_core_type *compiler,
  ins_stream_type *stream, char *str);
void stream_symbol(compiler_core_type *compiler,
  ins_stream_type *stream, char *str);

/* These are identical to bare */
void stream_bare(compiler_core_type *compiler,
  ins_stream_type *stream, node_type type, char *str);

#define stream_literal(comp, stream, num)  \
  stream_bare(comp, stream, STREAM_LITERAL, num)

#define stream_op(comp, stream, num)  \
  stream_bare(comp, stream, STREAM_OP, num)

/* Scheme parser */
int parse_internal(compiler_core_type *compiler, void *scanner);
void parse_error(compiler_core_type *compiler, void *scanner, char *s);

void parse_push_state(compiler_core_type *compiler, FILE *file);

/* Define some macros to make the parser code easier */
/*#define NEW_BUF(var) buffer_create(compiler->gc, &var)

#define EMIT(var, type, op) emit_##type(var, op)
#define EMIT_NEW(var, type, op) NEW_BUF(var); EMIT(var, type, op);*/

#define NEW_STREAM(var) stream_create(compiler, &var)

#define STREAM(var, type, ...) \
  stream_##type(compiler, var, ##__VA_ARGS__)

#define STREAM_NEW(var, type, ...) NEW_STREAM(var); \
  STREAM(var, type, ##__VA_ARGS__);

#endif
