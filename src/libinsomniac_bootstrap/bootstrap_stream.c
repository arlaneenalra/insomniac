#include "bootstrap_internal.h"

#include <string.h>
#include <assert.h>

#define BUILD_SINGLE_STREAM(name, type)                     \
void stream_##name(compiler_core_type *compiler,            \
  ins_stream_type *stream, ins_stream_type *body) {         \
                                                            \
    ins_node_type *ins_node = 0;                            \
                                                            \
    gc_register_root(compiler->gc, (void **)&ins_node);     \
                                                            \
    stream_alloc_node(compiler, type, &ins_node);           \
                                                            \
    ins_node->value.stream = body;                          \
                                                            \
    /* add the boolean to our instruction stream */         \
    stream_append(stream, ins_node);                        \
                                                            \
    gc_unregister_root(compiler->gc, (void **)&ins_node);   \
}                                                           

/* Allocate a new instruction node */
void stream_alloc_node(compiler_core_type *compiler, node_type type,
  ins_node_type **node) {

  gc_alloc_type(compiler->gc, 0, compiler->node_types[type], (void **)node);
  (*node)->type = type;
}

/* add source to the end of stream */
void stream_concat(ins_stream_type *stream, ins_stream_type *source) {

    /* This shouldn't happen, mostly for debugging/testing */
    if (!source) {
        fprintf(stderr, "Attempt to concat non-stream!\n");
        assert(0);
    }
    
    /* Make sure there is something to append */
    if (!source->head) {
        return;
    }

    /* Merge the to instruction lists */
    stream_append(stream, source->head);

    /* Update tail pointers */
    stream->tail = source->tail;
}

/* insert an instruction into the stream */
void stream_append(ins_stream_type *stream, ins_node_type *node) {

    /* Add a node to an empty stream */
    if (stream->tail == 0) {
        stream->head = stream->tail = node;
        return;
    }

    /* Add a node to a stream with enrtires */
    stream->tail->next = node;
    node->prev = stream->tail;
    stream->tail = node;
}

/* Create a stream instance */
void stream_create(compiler_core_type *compiler, ins_stream_type **stream) {
    gc_alloc_type(compiler->gc, 0, compiler->stream_gc_type, (void **)stream);
}

/* Quoted list node */
BUILD_SINGLE_STREAM(quoted, STREAM_QUOTED)

/* Load from symbol node */
BUILD_SINGLE_STREAM(load, STREAM_LOAD)

/* Build a boolean literal */
void stream_boolean(compiler_core_type *compiler,
  ins_stream_type *stream, int b) {

    char c = 't';
    ins_node_type *ins_node = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    /* if b is false, c should be f */
    if(!b) {
        c = 'f';
    }

    stream_alloc_node(compiler, STREAM_LITERAL, &ins_node);

    /* generate the literal string */
    gc_alloc(compiler->gc, 0, 4, (void **) &(ins_node->value.literal));
    snprintf(ins_node->value.literal, 4, "#%c", c);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

/* Build a Bare literals */
void stream_bare(compiler_core_type *compiler,
  ins_stream_type *stream, char *lit) {

    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    stream_alloc_node(compiler, STREAM_LITERAL, &ins_node);

    /* generate the literal string */
    length = strlen(lit) + 1;
    gc_alloc(compiler->gc, 0, length,
      (void **) &(ins_node->value.literal));

    strncpy(ins_node->value.literal, lit, length);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

/* Add a character literal */
void stream_char(compiler_core_type *compiler,
  ins_stream_type *stream, char *str) {

    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    stream_alloc_node(compiler, STREAM_LITERAL, &ins_node);

    /* generate the literal string */
    length = strlen(str) + 3;
    gc_alloc(compiler->gc, 0, length,
      (void **) &(ins_node->value.literal));

    snprintf(ins_node->value.literal, length, "#\\%s", str);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

/* Add a string literal */
void stream_string(compiler_core_type *compiler,
  ins_stream_type *stream, char *str) {

    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    stream_alloc_node(compiler, STREAM_LITERAL, &ins_node);

    /* generate the literal string */
    length = strlen(str) + 3;
    gc_alloc(compiler->gc, 0, length,
      (void **) &(ins_node->value.literal));

    snprintf(ins_node->value.literal, length, "\"%s\"", str);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

/* Add a symbol */
void stream_symbol(compiler_core_type *compiler,
  ins_stream_type *stream, char *str) {

    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    stream_alloc_node(compiler, STREAM_SYMBOL, &ins_node);

    /* generate the literal string */
    length = strlen(str) + 4;
    gc_alloc(compiler->gc, 0, length,
      (void **) &(ins_node->value.literal));

    snprintf(ins_node->value.literal, length, "s\"%s\"", str);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

