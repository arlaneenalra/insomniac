#ifndef _HASH_
#define _HASH_

#include "gc.h"

typedef uint32_t hash_type;

/* comparison type */
typedef enum {
    GT = 1,
    EQ = 0,
    LT = -1
} cmp_type;

/* definition of a simple hash table api */
typedef void hashtable_type;

/* definition of a hash function */
typedef hash_type (*hash_fn)(void *key);

typedef cmp_type(*hash_cmp)(void *key1, void *key2);

/* construct a new hash table instance */
hashtable_type *hash_create(gc_type *gc, hash_fn fn, 
                           hash_cmp cmp);

/* macro to make string hash tables easier to deal with */
#define hash_create_string(gc) \
    hash_create(gc, &hash_string, &hash_string_cmp)

/* bind a key and value in the given table */
void hash_set(hashtable_type *hash, void *key, void* value);

/* remove a given key from the table */
void hash_erase(hashtable_type *hash, void *key);


/* returns true on the key being found in the given
   hash table */
uint8_t hash_get(hashtable_type *hash, void *key, 
                 void **value);


void hash_info(hashtable_type *hash);

/* functions for string keyed hashtables */
hash_type hash_string(void *key);
cmp_type hash_string_cmp(void *key1, void *key2);

#endif
