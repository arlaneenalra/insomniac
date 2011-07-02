#ifndef _HASH_INTERNAL_
#define _HASH_INTERNAL_

#include <hash.h>

typedef struct hash_internal hash_internal_type;


typedef struct key_value {
    hash_type hash;
    void *key;
    void *value;
} key_value_type;


#endif
