#include "bootstrap_internal.h"

#include <stdio.h>

/*  Emit preamble code needed to boot strap the scheme system */
void emit_preamble(compiler_core_type *compiler) {
  size_t count = 0;

  count = buffer_load(compiler->buf, compiler->preamble);

  /* Make sure the preamble actually loaded */
  if (count == -1) {
    printf("Error loading preamble! %s", compiler->preamble);
    exit(-3);
  }
}
