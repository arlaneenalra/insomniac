#include "hash_internal.h"
#include <string.h>

/* Simple hash function for strings. Treats all 
   characters as single bytes. */
hash_type hash_string(void *key) {
    hash_type hash = 0;
    uint8_t *bytes = key;

    for(size_t i=0; bytes[i] != 0; i++) {
        /*hash *= 32;
        hash += bytes[i];*/
        /* see http://www.cse.yorku.ca/~oz/hash.html */
        hash = bytes[i] + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}

/* Wrapper for strncmp */
cmp_type hash_string_cmp(void *void_key1, void *void_key2) {
    // TODO: this looks an awful lot like strcmp ...
    uint8_t *key1 = (uint8_t *)void_key1;
    uint8_t *key2 = (uint8_t *)void_key2;

    while (*key1 == *key2 && *key1 != 0 && *key2 != 0) {
      key1++;
      key2++;
    }

    return *key1 == *key2 ? EQ :
           *key1 > *key2 ? GT : LT;
}
