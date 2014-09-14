#include "bootstrap_internal.h"

#include <stdio.h>

/*  Emit preamble code needed to boot strap the scheme system */
void emit_bootstrap(compiler_core_type *compiler) {
  gc_type *gc = compiler->gc;
  size_t count = 0;
  buffer_type *buf = 0;

  gc_register_root(gc, (void **)&buf);
  
  buffer_create(gc, &buf);

  /* load the preamble code into our buffer */
  count = buffer_load(buf, compiler->preamble);

  /* Make sure the preamble actually loaded */
  if (count == -1) {
    printf("Error loading preamble! %s", compiler->preamble);
    exit(-3);
  }

  /* append the compiled compiled code to the temp buffer */
  buffer_append(buf, compiler->buf, buffer_size(compiler->buf));

  /* load the post amble */
  if (compiler->postamble) {
    count = buffer_load(buf, compiler->postamble);
  }

  /* replace the compiler buffer with the new one */
  compiler->buf = buf;

  gc_unregister_root(gc, (void **)&buf);
}
