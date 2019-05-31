#include "gc_internal.h"

/* return a pointer to the meta object for a given object */
meta_obj_type *meta_from_obj(void *obj) {
    /* make sure a null stays a null */
    if (!obj) {
        return 0;
    }

    return (meta_obj_type *)(((uint8_t *)obj) - offsetof(meta_obj_type, obj));
}

/* return a pointer to the given object for a given meta object */
void *obj_from_meta(meta_obj_type *meta) {
    if (!meta) {
        return 0;
    }

    return &(meta->obj);
}
