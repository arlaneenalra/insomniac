#include "hash_internal.h"
#include <string.h>

/* Simple hash function for strings. Treats all 
   characters as single bytes. */
hash_type hash_string(void *key, size_t size) {
    hash_type hash = 0;
    uint8_t *bytes = key;

    for(size_t i=0; i < size; i++) {
        hash *= 32;
        hash += bytes[i];
    }
    return hash;
}

/* Wrapper for strncmp */
cmp_type hash_string_cmp(void *key1, size_t size1,
                         void *key2, size_t size2) {

    int result = 0;
    
    /* if the sizes are not equal, return not equal */
    if(size1 != size2) {
        return (size1 > size2) ? gt : lt;
    }

    /* both keys are of the same size */
    result = strncmp(key1, key2, size1);

    /* string are not equal */
    if(result != 0) {
        return (result > 0) ? gt : lt;
    }

    return eq;
}
