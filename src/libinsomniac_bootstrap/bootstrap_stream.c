#include "bootstrap_internal.h"

#include <string.h>
#include <assert.h>

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

/* Build a fixnum literal */
void stream_fixnum(compiler_core_type *compiler,
  ins_stream_type *stream, char *num) {

    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    stream_alloc_node(compiler, STREAM_LITERAL, &ins_node);

    /* generate the literal string */
    length = strlen(num) + 1;
    gc_alloc(compiler->gc, 0, length,
      (void **) &(ins_node->value.literal));

    strncpy(ins_node->value.literal, num, length);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

