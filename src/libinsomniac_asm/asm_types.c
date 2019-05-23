#include "asm_internal.h"

static gc_type_def debug_info_def = 0;

gc_type_def get_debug_info_def(gc_type *gc) {
    if (!debug_info_def) {
        debug_info_def = gc_register_type(gc, sizeof(debug_info_type));

        gc_register_pointer(gc, debug_info_def, offsetof(debug_info_type, files));
    }

    return debug_info_def;
}
