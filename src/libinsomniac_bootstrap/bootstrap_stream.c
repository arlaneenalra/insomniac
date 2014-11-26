#include "bootstrap_internal.h"

/* Allocate a new instruction node */
void stream_alloc_node(compiler_core_type *compiler, node_type type,
  ins_node_type **node) {

  gc_alloc_type(compiler->gc, 0, compiler->node_types[type],
    (void **)node);

    (*node)->type = type;
}

/* insert an instruction into the stream */
void stream_append(ins_stream_type *stream, ins_node_type *node) {
    stream->tail->next = node;
    stream->tail = node;
}

/* Create a stream instance */
void stream_create(compiler_core_type *compiler, ins_stream_type **stream) {
    gc_alloc_type(compiler->gc, 0, 
      compiler->stream_gc_type, (void **)stream);
}

void stream_boolean(compiler_core_type *compiler, ins_stream_type *stream,
  int b) {

    char c = 't';
    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    /* if b is false, c should be f */
    if(!b) {
        c = 'f';
    }

    stream_alloc_node(compiler, STREAM_LITERAL, &ins_node);

    /* generate the literal string */
    gc_alloc(compiler->gc, 0, 4, (void **) &(ins_node->value.literal));
    snprintf(ins_node->value.literal, 4, "#%c", c);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
}

