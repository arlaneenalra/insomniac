#include <stdio.h>
#include <assert.h>

#include <insomniac.h>



int test_hash(gc_type *gc, hash_type *hash) {
    char *key1 = 0;
    char *value = 0;
    char *expected = 0;

    gc_register_root(gc, (void **)&key1);
    gc_register_root(gc, (void **)&value);

    /* push values into the hash */
    for(int i=0; i <10; i++) {
        printf("Setting %i\n", i);
        /* an ineffcient means of doing this */
        key1 = gc_alloc(gc, 0, 40);
        value = gc_alloc(gc, 0, 40);

        snprintf(key1, 40, "k%i", i);
        snprintf(value, 40, "v%i", i);

        hash_set(hash, (void*)key1, strlen(key1), (void*)value);
    }


    for(int i=0; i <10; i++) {
        printf("Getting %i ->", i);
        /* an ineffcient means of doing this */
        key1 = gc_alloc(gc, 0, 40);
        expected = gc_alloc(gc, 0, 40);

        snprintf(key1, 40, "k%i", i);
        snprintf(expected, 40, "v%i", i);

        /* look up a key, we've previously set */
        if(hash_get(hash, (void*)key1, strlen(key1), (void **)&value)) {
            /* is the returned value what we expected? */
                printf("'%s': '%s' == '%s'\n",key1, expected, value);
            if(strcmp(expected, value) !=0) {
                return 1;
            }
            
        } else { /* test case failed */
            return 1;
        }
    }

    hash_info(hash);

    /* make sure that unset values actually fail */
    if(hash_get(hash, (void*)"bad", 3, (void**)&value)) {
        return 1;
    }

    gc_unregister_root(gc, (void **)&key1);
    gc_unregister_root(gc, (void **)&value);

    printf("\n");

    /* everything passed */
    return 0;
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));

    hashtable_type *hash = 0;

    /* make this a root to the garbage collector */
    gc_register_root(gc, &hash);

    
    /* create a hash table */
    hash = hash_create(gc, 
                       &hash_string,
                       &hash_string_cmp);

    /* exercise the hashtable */
    if(test_hash(gc, hash)) {
        /* something went wrong! */
        return 1;
    }
    

    gc_unregister_root(gc, &hash);

    gc_destroy(gc);

    return 0;
}
