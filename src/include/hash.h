#ifndef _HASH_
#define _HASH_

#include "gc.h"

typedef uint32_t hash_type;

/* comparison type */
typedef enum {
    gt = 1,
    eq = 0,
    lt = -1
} cmp_type;

/* definition of a simple hash table api */
typedef void hashtable_type;

/* definition of a hash function */
typedef hash_type (*hash_fn)(void *key, size_t size);

typedef cmp_type(*hash_cmp)(void *key1, size_t size1,
                          void *key2, size_t size2);

/* construct a new hash table instance */
hashtable_type *hash_create(gc_type *gc, hash_fn fn, 
                           hash_cmp cmp);

/* bind a key and value in the given table */
void hash_set(hashtable_type *hash, void *key, size_t size,
              void* value);

/* remove a given key from the table */
void hash_erase(hashtable_type *hash, void *key, 
                size_t size);


/* returns true on the key being found in the given
   hash table */
uint8_t hash_get(hashtable_type *hash, void *key, 
                 size_t size, void **value);

/* functions for string keyed hashtables */
hash_type hash_string(void *key, size_t size);
cmp_type hash_string_cmp(void *key1, size_t size1,
                         void *key2, size_t size2);

#endif
