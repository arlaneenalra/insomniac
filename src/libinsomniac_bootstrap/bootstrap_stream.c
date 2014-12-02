#include "bootstrap_internal.h"

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


