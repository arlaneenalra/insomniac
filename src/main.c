#include <stdio.h>
#include <assert.h>

#include <insomniac.h>
#include <ops.h>

#include <locale.h>


void assemble_work(buffer_type *buf) {
    EMIT_LIT_EMPTY(buf);

    /* create a fix num */
    for(int i=0; i<10;i++) {
        EMIT_LIT_FIXNUM(buf, i);
        EMIT_CONS(buf);
        EMIT_LIT_TRUE(buf);
        EMIT_CONS(buf);
    }

    EMIT_LIT_STRING(buf, "END");

    /* create a fix num */
    for(int i=0; i<30;i++) {
        EMIT_LIT_FIXNUM(buf, i);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x03BB);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x30CA);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x01D5);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x1D2C);
        EMIT_CONS(buf);

        EMIT_LIT_FIXNUM(buf, 10);
        EMIT_MAKE_VECTOR(buf);

        for(int y = 0; y < 10 ; y++) {
            EMIT_DUP_REF(buf);
            EMIT_LIT_FIXNUM(buf, y);
            EMIT_LIT_STRING(buf, "Hi");
            /* EMIT_MAKE_SYMBOL(buf);*/
            EMIT_CONS(buf);
            EMIT_LIT_FIXNUM(buf, y);
            EMIT_VECTOR_SET(buf);
        }

        EMIT_DUP_REF(buf);
        EMIT_LIT_FIXNUM(buf, 1);
        EMIT_VECTOR_REF(buf);
    }

}

void test_hash(gc_type *gc, hash_type *hash) {
    char *key1 = 0;
    char *value = 0;

    gc_register_root(gc, (void **)&key1);
    gc_register_root(gc, (void **)&value);

    for(int i=0; i <10; i++) {
        printf("Setting %i\n", i);
        /* an ineffcient means of doing this */
        key1 = gc_alloc(gc, 0, 40);
        value = gc_alloc(gc, 0, 40);

        snprintf(key1, 40, "k%i", i);
        snprintf(value, 40, "v%i", i);

        hash_set(hash, (void*)key1, strlen(key1), (void*)value);
    }


    for(int i=0; i <12; i++) {
        printf("Getting %i ->", i);
        /* an ineffcient means of doing this */
        key1 = gc_alloc(gc, 0, 40);

        snprintf(key1, 40, "k%i", i);


        /* look up a key, we've previously set */
        if(hash_get(hash, (void*)key1, strlen(key1), (void **)&value)) {
            printf("'%s'\n", value);
        } else {
            printf("NOT SET\n");
        }
    }


    gc_unregister_root(gc, (void **)&key1);
    gc_unregister_root(gc, (void **)&value);
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = 0; 

    size_t length=0;
    size_t written=0;
    buffer_type *buf = 0;
    uint8_t *code_ref = 0;
    hashtable_type *hash = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");
    printf("'%lc' lambda\n", 0x03BB);

    /* make this a root to the garbage collector */
    gc_register_root(gc, &buf);
    gc_register_root(gc, &vm);
    gc_register_root(gc, (void **)&code_ref);
    gc_register_root(gc, &hash);

    vm = vm_create(gc);

    buf = buffer_create(gc);

    assemble_work(buf);

    length = buffer_size(buf);
    printf("Size %zu\n", length);
    gc_stats(gc);

    /* create a code ref */
    code_ref = gc_alloc(gc, 0, length);
    written = buffer_read(buf, &code_ref, length);
    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);

    printf("Evaluating\n");

    vm_output_object(stdout, vm_eval(vm, length, code_ref));
    printf("\n");

    vm_reset(vm);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);
    printf("Evaluating\n");

    vm_output_object(stdout, vm_eval(vm, length, code_ref));
    printf("\n");

    vm_reset(vm);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);
    
    /* create a hash table */
    hash = hash_create(gc, 
                       &hash_string,
                       &hash_string_cmp);

    /* exercise the hashtable */
    test_hash(gc, hash);
    
    vm_destroy(vm);

    gc_unregister_root(gc, &hash);
    gc_unregister_root(gc, (void **)&code_ref);
    gc_unregister_root(gc, &vm);
    gc_unregister_root(gc, &buf);

    gc_destroy(gc);

    return 0;
}
