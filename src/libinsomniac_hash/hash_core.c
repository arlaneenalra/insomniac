#include "hash_internal.h"
#include <math.h>
#include <stdio.h>


/* create a hashtable using the given function and 
   comparator */
void hash_create(gc_type *gc, hash_fn fn,
                 hash_cmp cmp, hashtable_type **ret) {
    
    static gc_type_def hashtable_type_def = 0;
    static gc_type_def key_value_type_def = 0;
    hash_internal_type *table = 0;
    
    /* register the hashtable type with the gc */
    if(!hashtable_type_def) {
        hashtable_type_def = register_hashtable(gc);
        key_value_type_def = register_key_value(gc);
    }
    
    gc_register_root(gc, (void**)&table);

    gc_alloc_type(gc, 0, hashtable_type_def, (void **)&table);

    table->gc = gc;
    table->calc_hash = fn;
    table->compare = cmp;
    
    /* resize the hashtable */
    hash_resize(table, HASH_SIZE);

    /* table->key_value = register_key_value(gc); */
    table->key_value = key_value_type_def;

    *ret = (hashtable_type *)table;

    gc_unregister_root(gc, (void**)&table);
}

/* add a value to the hash */
void hash_set(hashtable_type *void_table, void *key, void * value) {
    key_value_type *kv = 0;

    hash_internal_type *table=(hash_internal_type *)void_table;
    size_t new_size = 0;

    kv = hash_find(table, key, CREATE);
    kv->value = value;

    /* check to see if we need to resize hash */
    if(hash_load(table) > MAX_LOAD) {
        /* calculate new size */
        new_size = floor(table->entries / TARGET_LOAD) + 1;
        hash_resize(table, new_size);
    }
}

/* remove a key from the tables */
void hash_erase(hashtable_type *void_table, void *key) {
    hash_internal_type *table=(hash_internal_type *)void_table;
    hash_find(table, key, DELETE);
}

/* retrieve the value bound to a key in the table */
uint8_t hash_get(hashtable_type *void_table, void *key, void ** value) {
    key_value_type *kv = 0;
    hash_internal_type *table = (hash_internal_type *)void_table;

    kv = hash_find(table, key, READ);

    /* does the given key exist in the table ?*/
    if(!kv) {
        return 0;
    }
    
    /* we found the value, do we have 
     somewhere to put it? */
    if(value) {
        *(value) = kv->value;
    }
    return 1;
}


/* locate or create a key_value_object the given key */
key_value_type *hash_find(hash_internal_type *table,
                          void *key, hash_action_type action) {
    hash_type hash = (*table->calc_hash)(key);
    hash_type index = hash % table->size; /* calculate the search table index */
    key_value_type *kv = 0;
    key_value_type *prev_kv = 0;


    /* is there anything at the given index? */
    if((kv = table->table[index])) {
        /* search through the list of key value pairs */
        while(kv) {
            if((*table->compare)(key, kv->key) == EQ) {

                /* do the delete if needed */
                if(action == DELETE) {
                    
                    /* Do we have a chain? */
                    if(prev_kv) {
                        /* Remove node from chain */
                        prev_kv->next = kv->next;
                    } else {
                        /* This node is either the head of a chain
                           or there is no chain.  */
                        table->table[index] = kv->next;
                    }
                }
                return kv;
            }
            prev_kv = kv;
            kv = kv->next;
        }
    }
    
    /* we did not find the key, should we create it? */
    if(action == CREATE) {
        gc_register_root(table->gc, (void**)&kv);

        gc_alloc_type(table->gc, 0, table->key_value, (void **)&kv);

        kv->key = key;

        /* attach kv to table */
        kv->next = table->table[index];
        table->table[index] = kv;

        table->entries++;

        gc_unregister_root(table->gc, (void**)&kv);

        return kv;
    }

    
    return 0;
}

/* resize/allocagte hashtable array */
void hash_resize(hash_internal_type *table, size_t size) {
    key_value_type **old_table = 0;
    key_value_type *kv = 0;
    size_t old_size = 0;

    gc_register_root(table->gc, (void **)&old_table);

    old_table = table->table;
    old_size = table->size;

    gc_alloc_pointer_array(table->gc,
			   0,
			   size,
			   (void **)&(table->table));
    table->size = size;
    table->entries = 0;

    /* do we need to copy old entries into 
       the new table */
    if(old_table) {
        /* enumerate all old entries and add them to the
           new table */

        for(int i=0; i < old_size; i++) {
            kv = old_table[i];
            while(kv) {
                /* save the previous value in the new
                   table */
                hash_find(table, kv->key, CREATE)
                    ->value = kv->value;

                kv = kv->next;
            }
        }
    }
    
    gc_unregister_root(table->gc, (void **)&old_table);
}

/* calculate the load factor for a given table */
float hash_load(hash_internal_type *table) {
    return (table->entries * 1.0) / table->size;
}


/* output some useful stats about a hash table */
void hash_info(hashtable_type *void_table) {
    hash_internal_type *table=(hash_internal_type *)void_table;
    key_value_type *kv = 0;

    uint64_t max = 0;
    uint64_t current = 0;

    uint64_t active_chains = 0;


    printf("Hash Info: Entries %lu Size %lu Load %f\n",
           table->entries, table->size, hash_load(table));

    printf("\tHash Keys: ");
    for(int i=0; i < table->size; i++) {
        kv = table->table[i];
        current = 0;

        while(kv) {
            /* save the previous value in the new
               table */
            printf(" %s", (char *)kv->key);
            current++;
            kv = kv->next;
        }

        if(current > 0 ) {
            active_chains++;
        }

        if(current > max ) {
            max = current;
        }
    }
    
    printf("\n\tLongest Chain %" PRIi64 " Active Chains %" PRIi64 " Average Chain %f\n",
           max, active_chains, (table->entries * 1.0) / active_chains);
}
