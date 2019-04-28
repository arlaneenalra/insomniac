#include "hash_internal.h"

/* Simple pointer hashing function */
hash_type hash_pointer(void *key) {
    hash_type hash = 0;
    uint8_t *bytes = (uint8_t *)&key;

    for(size_t i=0; i < sizeof(void *); i++) {
        hash *= 32;
        hash += bytes[i];
    }

    return hash;
}

/* simple pointer comparison */
cmp_type hash_pointer_cmp(void *key1, void *key2) {


    if(key1 > key2) {
        return GT;

    } else if (key1 < key2) {
        return LT;
    }

    return EQ;
}
