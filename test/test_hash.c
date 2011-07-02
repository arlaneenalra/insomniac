#include <stdio.h>
#include <assert.h>

#include <insomniac.h>
#include <test.h>

gc_type *gc;
hashtable_type *hash;

char *key1 = 0;
char *value = 0;
char *expected = 0;


/* Global Setup and Tear Down hooks */
void setup_hook() {
    gc = gc_create(sizeof(object_type));

    /* make this a root to the garbage collector */
    gc_register_root(gc, &hash);
    gc_register_root(gc, (void **)&key1);
    gc_register_root(gc, (void **)&value);


}

void tear_down_hook() {
    gc_unregister_root(gc, (void **)&value);
    gc_unregister_root(gc, (void **)&key1);
    gc_unregister_root(gc, &hash);
    
    /* Shutdown the GC */
    gc_destroy(gc);
}

void build_hash() {

    /* create a hash table */
    hash = hash_create(gc, 
                       &hash_string,
                       &hash_string_cmp);


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

}


/* Test to see if we can retrieve data written to the hash */
int test_read() {

    build_hash();

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
                printf("'%s': '%s' == '%s'",key1, expected, value);
            if(strcmp(expected, value) !=0) {
                return 1;
            }
            
        } else { /* test case failed */
            return 1;
        }

        printf("\n");
    }

    /* everything passed */
    return 0;
}

int test_bad_read() {

    build_hash();

    /* make sure that unset values actually fail */
    if(hash_get(hash, (void*)"bad", 3, (void**)&value)) {
        return 1;
    }

    return 0;
}


/* define the test cases */
test_case_type cases[] = {
    {&test_read, "Testing Set/Read Hash"},
    {&test_bad_read, "Testing Read for non-existent value Hash"},
    /* {&test_bad_read, "Testing Read for non-existent value Hash"},*/
    {0,0} /* end of list token */
};
