#ifndef _HASH_INTERNAL_
#define _HASH_INTERNAL_

#include <gc.h>
#include <hash.h>

#define HASH_SIZE 4

typedef struct hash_internal hash_internal_type;
typedef struct key_value key_value_type;


struct key_value {
    hash_type hash;
    void *key;
    size_t size;
    void *value;

    key_value_type *next;
};

struct hash_internal {
    gc_type *gc;
    hash_fn calc_hash;
    hash_cmp compare;

    key_value_type *table;
    size_t size;
};

/* type registration functions */
gc_type_def register_hashtable(gc_type *gc);
gc_type_def register_key_value(gc_type *gc);

/* resize/allocate hashtable array */
void hash_resize(hash_internal_type *table, size_t size);

#endif
