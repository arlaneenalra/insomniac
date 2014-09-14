#include "bootstrap_internal.h"

#include <string.h>

/*  Emit preamble code needed to boot strap the scheme system */
void emit_preamble(compiler_core_type *compiler) {
  char *preamble = ""; 

  buffer_write(compiler->buf, (uint8_t *)preamble, strlen(preamble));
}
