#include "gc_internal.h"
#include <string.h>

/* register a new type with the GC */
gc_type_def gc_register_type(gc_type *gc_void, size_t size) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    size_t array_size = sizeof(meta_obj_def_type) * (gc->num_types + 1);
    meta_obj_def_type *type_defs = 0;

    uint32_t new_type = gc->num_types;

    /* if we don't have any types defined, define a new
       array */
    if (!gc->num_types) {
        gc->type_defs = MALLOC(array_size);

    } else {
        /* redefine array and copy */
        type_defs = MALLOC(array_size);

        memcpy(type_defs, gc->type_defs, sizeof(meta_obj_def_type) * (gc->num_types));
        FREE(gc->type_defs);
        gc->type_defs = type_defs;
    }

    gc->num_types++;

    gc->type_defs[new_type].root_list = 0;
    gc->type_defs[new_type].size = size;

    return new_type;
}

/* register a pointer offset with the GC */
void gc_register_pointer(gc_type *gc_void, gc_type_def type, size_t offset) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_ptr_def_type *meta_type = MALLOC_TYPE(meta_obj_ptr_def_type);

    meta_type->next = gc->type_defs[type].root_list;
    meta_type->type = PTR;
    meta_type->offset = offset;
    gc->type_defs[type].root_list = meta_type;
}

/* register a pointer offset with the GC */
void gc_register_array(gc_type *gc_void, gc_type_def type, size_t offset) {
    gc_ms_type *gc = (gc_ms_type *)gc_void;
    meta_obj_ptr_def_type *meta_type = MALLOC_TYPE(meta_obj_ptr_def_type);

    meta_type->next = gc->type_defs[type].root_list;
    meta_type->type = ARRAY;
    meta_type->offset = offset;
    gc->type_defs[type].root_list = meta_type;
}

/* clean up when shutting down a GC instance */
void destroy_types(gc_ms_type *gc, meta_obj_def_type *type_list, uint32_t num_types) {
    meta_obj_ptr_def_type *next = 0;
    meta_obj_ptr_def_type *type_def = 0;

    for (int i = 0; i < num_types; i++) {
        type_def = type_list[i].root_list;

        while (type_def) {
            next = type_def->next;

            FREE(type_def);

            type_def = next;
        }
    }
    FREE(type_list);
}
