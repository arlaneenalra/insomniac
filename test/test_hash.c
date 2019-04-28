#include <stdio.h>
#include <string.h>
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
    hash_create(gc,
                &hash_string,
                &hash_string_cmp,
                &hash);


    /* push values into the hash */
    for(int i=0; i <10; i++) {
        /* an ineffcient means of doing this */
        gc_alloc(gc, 0, 40, (void **)&key1);
        gc_alloc(gc, 0, 40, (void **)&value);

        snprintf(key1, 40, "k%i", i);
        snprintf(value, 40, "v%i", i);

        hash_set(hash, (void*)key1, (void*)value);
    }

}

int test_gc() {

    build_hash();
    gc_sweep(gc);
    build_hash();
    gc_sweep(gc);

    return 0;
}


/* Test to see if we can retrieve data written to the hash */
int test_read() {

    build_hash();

    for(int i=0; i <10; i++) {
        /* an ineffcient means of doing this */
        gc_alloc(gc, 0, 40, (void **)&key1);
        gc_alloc(gc, 0, 40, (void **)&expected);

        snprintf(key1, 40, "k%i", i);
        snprintf(expected, 40, "v%i", i);

        /* look up a key, we've previously set */
        if(hash_get(hash, (void*)key1, (void **)&value)) {
            /* is the returned value what we expected? */
            if(strcmp(expected, value) !=0) {
                printf("'%s': '%s' != '%s'\n",key1, expected, value);
                return 1;
            }

        } else { /* test case failed */
            return 1;
        }

    }

    /* everything passed */
    return 0;
}

/* Test for a bad read */
int test_bad_read() {

    build_hash();

    /* make sure that unset values actually fail */
    if(hash_get(hash, (void*)"bad", (void**)&value)) {
        return 1;
    }

    return 0;
}

/* Test that we can erase a key from the table */
int test_erase() {

    build_hash();

    /* The key should no longer be found */
    if(!hash_get(hash, (void*)"k1", (void**)&value)) {
        printf("Key k1 missing from initial hash.\n");
        return 1;
    }

    /* make sure that unset values actually fail */
    hash_erase(hash, (void*)"k1");

    value = "";

    /* The key should no longer be found */
    if(hash_get(hash, (void*)"k1", (void**)&value)) {
        printf("Found: '%s'\n", value);

        return 1;
    }

    return 0;
}



/* define the test cases */
test_case_type cases[] = {
    {&test_read, "Testing Set/Read Hash"},
    {&test_bad_read, "Testing Read for non-existent value Hash"},
    {&test_erase, "Testing Erase Hash"},
    {&test_gc, "Testing GC of Hash Stored objects"},
    /* {&test_bad_read, "Testing Read for non-existent value Hash"},*/
    {0,0} /* end of list token */
};
