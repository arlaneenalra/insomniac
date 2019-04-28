#include "hash_internal.h"

gc_type_def register_hashtable(gc_type *gc) {
    gc_type_def hashtable = 0;

    hashtable = gc_register_type(gc, sizeof(hash_internal_type));

    /* register the table itself */
    gc_register_pointer(gc, hashtable, offsetof(hash_internal_type, table));

    return hashtable;
}

gc_type_def register_key_value(gc_type *gc) {
    gc_type_def key_value = 0;

    key_value = gc_register_type(gc, sizeof(key_value_type));

    gc_register_pointer(gc, key_value, offsetof(key_value_type, key));

    gc_register_pointer(gc, key_value, offsetof(key_value_type, value));

    gc_register_pointer(gc, key_value, offsetof(key_value_type, next));

    return key_value;
}
