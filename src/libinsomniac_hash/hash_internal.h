#ifndef _HASH_INTERNAL_
#define _HASH_INTERNAL_

#include <gc.h>
#include <hash.h>

#define HASH_SIZE 4
#define MAX_LOAD 0.9
#define TARGET_LOAD 0.6

typedef struct hash_internal hash_internal_type;
typedef struct key_value key_value_type;

typedef enum {
    READ,
    DELETE,
    CREATE
} hash_action_type;

struct key_value {
    void *key;
    void *value;

    key_value_type *next;
};

struct hash_internal {
    gc_type *gc;
    hash_fn calc_hash;
    hash_cmp compare;

    key_value_type **table;
    size_t size;
    size_t entries;

    gc_type_def key_value;
};

/* type registration functions */
gc_type_def register_hashtable(gc_type *gc);
gc_type_def register_key_value(gc_type *gc);

/* resize/allocate hashtable array */
void hash_resize(hash_internal_type *table, size_t size);
key_value_type *hash_find(hash_internal_type *table,
                          void *key, hash_action_type create);

float hash_load(hash_internal_type *table);

#endif
