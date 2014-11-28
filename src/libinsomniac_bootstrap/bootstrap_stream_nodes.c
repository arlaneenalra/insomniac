#include "bootstrap_internal.h"

#include <string.h>
#include <assert.h>

#define BUILD_SINGLE_STREAM(name, type)                     \
BUILD_SINGLE_SIGNATURE(name) {                              \
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


/* Single stream nodes */
BUILD_SINGLE_STREAM(quoted, STREAM_QUOTED)
BUILD_SINGLE_STREAM(load, STREAM_LOAD)
BUILD_SINGLE_STREAM(bind, STREAM_BIND)
BUILD_SINGLE_STREAM(asm, STREAM_ASM)

/* Build a bare asm instruction/literal */
void stream_bare(compiler_core_type *compiler, ins_stream_type *stream,
  node_type type, char *lit) {

    ins_node_type *ins_node = 0;
    size_t length = 0;

    gc_register_root(compiler->gc, (void **)&ins_node);

    stream_alloc_node(compiler, type, &ins_node);

    /* generate the literal string */
    length = strlen(lit) + 1;
    gc_alloc(compiler->gc, 0, length,
      (void **) &(ins_node->value.literal));

    strncpy(ins_node->value.literal, lit, length);

    /* add the boolean to our instruction stream */
    stream_append(stream, ins_node);
    
    gc_unregister_root(compiler->gc, (void **)&ins_node);
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

