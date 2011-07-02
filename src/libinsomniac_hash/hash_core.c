#include "hash_internal.h"


/* create a hashtable using the given function and 
   comparator */
hashtable_type *hash_create(gc_type *gc, hash_fn fn,
                            hash_cmp cmp) {
    
    static gc_type_def hashtable_type_def = 0;
    hash_internal_type *table;
    
    /* register the hashtable type with the gc */
    if(!hashtable_type_def) {
        hashtable_type_def = register_hashtable(gc);
    }
    
    gc_register_root(gc, (void**)&table);

    table = gc_alloc_type(gc, 0, hashtable_type_def);

    table->gc = gc;
    table->calc_hash = fn;
    table->compare = cmp;
    
    /* resize the hashtable */
    hash_resize(table, HASH_SIZE);

    table->key_value = register_key_value(gc);


    gc_unregister_root(gc, (void**)&table);
    
    return (hashtable_type *)table;
}

/* add a value to the hash */
void hash_set(hashtable_type *void_table, void *key, size_t size,
              void * value) {
    key_value_type *kv = 0;

    hash_internal_type *table=(hash_internal_type *)void_table;
    kv = hash_find(table, key, size, 1);
    kv->value = value;
}

uint8_t hash_get(hashtable_type *void_table, void *key, size_t size, void ** value) {
    key_value_type *kv = 0;
    hash_internal_type *table=(hash_internal_type *)void_table;
    kv = hash_find(table, key, size, 0);

    /* does the given key exist in the table ?*/
    if(!kv) {
        return 0;
    }
    
    /* we found the value */
    *(value) = kv->value;
    return 1;
}


/* locate or create a key_value_object the given key */
key_value_type *hash_find(hash_internal_type *table,
                          void *key, size_t size, uint8_t create) {
    hash_type hash = (*table->calc_hash)(key, size);
    hash_type index = hash % table->size; /* calculate the search table index */
    key_value_type *kv = 0;

    /* is there anything at the given index? */
    if((kv = table->table[index])) {
        /* search through the list of key value pairs */
        while(kv) {
            if((*table->compare)(key, size, kv->key, kv->size) == EQ) {
                return kv;
            }
            kv = kv->next;
        }
    }
    
    /* we did not find the key, should we create it? */
    if(create) {
        kv = gc_alloc_type(table->gc, 0, table->key_value);

        kv->hash = hash;
        kv->key = key;
        kv->size = size;

        kv->next = table->table[index];
        table->table[index] = kv;
    }

    
    return kv;
}

/* resize/allocagte hashtable array */
void hash_resize(hash_internal_type *table, size_t size) {
    key_value_type *new_table = 0;

    /* do we have an existing table ? */
    if(!table->table) {
        table->table = gc_alloc_pointer_array(table->gc,
                                              0,
                                              size);
        table->size = size;
        return;
    }

    gc_register_root(table->gc, (void **)&new_table);

    /* TODO: Add in resizing code here */

    gc_unregister_root(table->gc, (void **)&new_table);
}
