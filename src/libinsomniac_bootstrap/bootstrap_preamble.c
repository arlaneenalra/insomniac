#include "bootstrap_internal.h"

#include <string.h>

/*  Emit preamble code needed to boot strap the scheme system */
void emit_bootstrap(compiler_core_type *compiler, buffer_type *out_buf) {
  gc_type *gc = compiler->gc;
  size_t count = 0;
  buffer_type *buf = 0;
  char path[PATH_MAX];

  gc_register_root(gc, (void **)&buf);

  buffer_create(gc, &buf);


  /* load the preamble code into our buffer */
  strcpy(path, compiler->home);
  strcat(path, "/lib/preamble.asm");
  count = buffer_load(buf, path);

  /* Make sure the preamble actually loaded */
  if (count == -1) {
    fprintf(stderr, "Error loading preamble! %s", path);
    exit(-3);
  }

  /* append the compiled compiled code to the temp buffer */
  buffer_append(buf, out_buf, -1);

  /* load the post amble */
  strcpy(path, compiler->home);
  strcat(path, "/lib/postamble.asm");
  count = buffer_load(buf, path);

  if (count == -1) {
    fprintf(stderr, "Error loading postamble! %s", path);
    exit(-4);
  }

  /* replace the compiler buffer with the new one */
  /* out_buf = buf; */
   buffer_reset(out_buf);

  buffer_append(out_buf, buf, -1);

  gc_unregister_root(gc, (void **)&buf);
}

