#include "asm_internal.h"

static gc_type_def debug_info_def = 0;
static gc_type_def debug_state_def = 0;

gc_type_def get_debug_info_def(gc_type *gc) {
    if (!debug_info_def) {
        debug_info_def = gc_register_type(gc, sizeof(debug_info_type));

        gc_register_pointer(gc, debug_info_def, offsetof(debug_info_type, files));
        gc_register_pointer(gc, debug_info_def, offsetof(debug_info_type, head));
    }

    return debug_info_def;
}

gc_type_def get_debug_state_def(gc_type *gc) {
    if (!debug_state_def) {
        debug_state_def = gc_register_type(gc, sizeof(debug_state_type));
        
        gc_register_pointer(gc, debug_state_def, offsetof(debug_state_type, file));
        gc_register_pointer(gc, debug_state_def, offsetof(debug_state_type, next));
    }
    
    return debug_state_def;
}
