#ifndef _HASH_
#define _HASH_

#include "gc.h"

typedef uint32_t hash_type;

/* comparison type */
typedef enum { GT = 1, EQ = 0, LT = -1 } cmp_type;

/* definition of a simple hash table api */
typedef void hashtable_type;
typedef void hash_iterator_type;

/* hash table entry */
typedef struct hash_entry {
   void *key;
   void *value;
} hash_entry_type;

/* definition of a hash function */
typedef hash_type (*hash_fn)(void *key);

typedef cmp_type (*hash_cmp)(void *key1, void *key2);

/* construct a new hash table instance */
void hash_create(gc_type *gc, hash_fn fn, hash_cmp cmp, hashtable_type **ret);

/* duplicate an existing hash table in cow mode */
void hash_cow(gc_type *gc, hashtable_type *src, hashtable_type **ret);

/* macro to make string hash tables easier to deal with */
#define hash_create_string(gc, ret) hash_create(gc, &hash_string, &hash_string_cmp, ret)

/* macro to make string hash tables easier to deal with */
#define hash_create_pointer(gc, ret)                                                     \
    hash_create(gc, &hash_pointer, &hash_pointer_cmp, ret)

/* bind a key and value in the given table */
void hash_set(hashtable_type *hash, void *key, void *value);

/* remove a given key from the table */
void hash_erase(hashtable_type *hash, void *key);

/* returns true on the key being found in the given
   hash table */
uint8_t hash_get(hashtable_type *hash, void *key, void **value);

void hash_info(hashtable_type *hash);

/* iterate through entries in the given hash table */
hash_entry_type *hash_next(hashtable_type *table, hash_iterator_type **iterator);

/* Returns the current size of a hash table */
int hash_size(hashtable_type *table);

/* functions for string keyed hashtables */
hash_type hash_string(void *key);
cmp_type hash_string_cmp(void *key1, void *key2);

/* functions for pointer keyed hashtables */
hash_type hash_pointer(void *key);
cmp_type hash_pointer_cmp(void *key1, void *key2);

#endif
