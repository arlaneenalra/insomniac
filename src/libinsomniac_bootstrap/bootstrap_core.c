
#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#include <stdio.h>

/* Emit a boolean into our code stream */
void emit_bool(compiler_core_type *compiler, int b) {
    char c='t';

    /* if b is false, c should be f */
    if(!b) {
        c = 'f';
    }

    printf("#%c", c);
}
