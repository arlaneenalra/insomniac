#include "gc_internal.h"

#include <string.h>

/* Convert a non-gc string into one managed by the gc */
void gc_make_substring(gc_type *gc, const char *src, char **gc_str, int len) {
    gc_alloc(gc, 0, len + 1, (void **)gc_str);

    /* subtract one to remove the extra " */
    strncpy(*gc_str, src, len);
}

