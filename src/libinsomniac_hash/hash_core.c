#include "hash_internal.h"
#include <math.h>
#include <stdio.h>

static gc_type_def hashtable_type_def = 0;
static gc_type_def key_value_type_def = 0;
static gc_type_def hash_iterator_def = 0; 

/* create a hashtable using the given function and
   comparator */
void hash_create(gc_type *gc, hash_fn fn, hash_cmp cmp, hashtable_type **ret) {

    hash_internal_type *table = 0;

    /* register the hashtable type with the gc */
    if (!hashtable_type_def) {
        hashtable_type_def = register_hashtable(gc);
        key_value_type_def = register_key_value(gc);
        hash_iterator_def = register_hash_iterator(gc);
    }

    gc_register_root(gc, (void **)&table);

    gc_alloc_type(gc, 0, hashtable_type_def, (void **)&table);

    table->gc = gc;
    table->calc_hash = fn;
    table->compare = cmp;
    table->copy_on_write = false;

    /* resize the hashtable */
    hash_resize(table, HASH_SIZE);

    table->key_value = key_value_type_def;

    *ret = (hashtable_type *)table;

    gc_unregister_root(gc, (void **)&table);
}

/* create a cow copy of an existing hashtable */
void hash_cow(gc_type *gc, hashtable_type *src, hashtable_type **ret) {
    hash_internal_type **table = (hash_internal_type **)ret;

    /* allocate the new hashtable instance */
    gc_alloc_type(gc, 0, hashtable_type_def, (void **)table);

    /* copy the entire contents of the hashtable into the new one */
    memcpy(*table, src, sizeof(hash_internal_type));

    (*table)->copy_on_write = true;
}

/* add a value to the hash */
void hash_set_stateful(hashtable_type *void_table, void *key, void *value, hash_state_type *hash) {
    key_value_type kv_in = {0, 0};
    key_value_type *kv = 0;

    hash_internal_type *table = (hash_internal_type *)void_table;
    size_t new_size = 0;

    kv_in.key = key;

    /* Allow external caching of the hash value for faster lookups. */
    if (hash && hash->set) {
        kv_in.hash = hash->hash;
    } else {
        kv_in.hash = (*table->calc_hash)(key);
        if (hash) {
            hash->hash = kv_in.hash;
            hash->set = true;
        }
    }

    kv = hash_find_kv(table, &kv_in, CREATE);
    kv->value = value;

    /* check to see if we need to resize hash */
    if (hash_load(table) > MAX_LOAD) {
        /* calculate new size */
        new_size = floor(table->entries / TARGET_LOAD) + 1;
        hash_resize(table, new_size);
    }
}

/* remove a key from the tables */
void hash_erase(hashtable_type *void_table, void *key) {
    hash_internal_type *table = (hash_internal_type *)void_table;
    hash_find(table, key, DELETE);
}

/* retrieve the value bound to a key in the table */
uint8_t hash_get_stateful(hashtable_type *void_table, void *key, void **value, hash_state_type *hash) {
    key_value_type kv_in;
    key_value_type *kv = 0;
    hash_internal_type *table = (hash_internal_type *)void_table;

    kv_in.key = key;

    /* Allow external caching of the hash value for faster lookups. */
    if (hash && hash->set) {
        kv_in.hash = hash->hash;
    } else {
        kv_in.hash = (*table->calc_hash)(key);
        if (hash) {
            hash->hash = kv_in.hash;
            hash->set = true;
        }
    }

    kv = hash_find_kv(table, &kv_in, READ);

    /* does the given key exist in the table ?*/
    if (!kv) {
        return 0;
    }

    /* we found the value, do we have
     somewhere to put it? */
    if (value) {
        *(value) = kv->value;
    }
    return 1;
}

/* locate or create a key_value_object the given key */
key_value_type *hash_find(hash_internal_type *table, void *key, hash_action_type action) {
    key_value_type kv;

    kv.key = key;
    kv.hash = (*table->calc_hash)(key);

    return hash_find_kv(table, &kv, action);
}

/* locate or create a key_value_object the given key_value */
key_value_type *hash_find_kv(hash_internal_type *table, key_value_type* kv_in, hash_action_type action) {
    void *key = kv_in->key;
    hash_type index = kv_in->hash % table->size;
    key_value_type *kv = 0;
    key_value_type *prev_kv = 0;

    /* Check for "write" operations and a COW hash */
    if (table->copy_on_write && (action == CREATE || action == DELETE)) {
        /* resize implicitly copies everything */
        hash_resize(table, table->size);

        table->copy_on_write = false;
    }

    /* is there anything at the given index? */
    if ((kv = table->table[index])) {
        /* search through the list of key value pairs */
        while (kv) {
            if ((*table->compare)(key, kv->key) == EQ) {

                /* do the delete if needed */
                if (action == DELETE) {

                    /* Do we have a chain? */
                    if (prev_kv) {
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
    if (action == CREATE) {
        gc_register_root(table->gc, (void **)&kv);

        gc_alloc_type(table->gc, 0, table->key_value, (void **)&kv);

        kv->key = key;
        kv->hash = kv_in->hash;

        /* attach kv to table */
        kv->next = table->table[index];
        table->table[index] = kv;

        table->entries++;

        gc_unregister_root(table->gc, (void **)&kv);

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

    gc_alloc_pointer_array(table->gc, 0, size, (void **)&(table->table));
    table->size = size;
    table->entries = 0;

    /* do we need to copy old entries into
       the new table */
    if (old_table) {
        /* enumerate all old entries and add them to the
           new table */

        for (int i = 0; i < old_size; i++) {
            kv = old_table[i];
            while (kv) {
                /* save the previous value in the new
                   table */
                hash_find_kv(table, kv, CREATE)->value = kv->value;

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

/* return the size of the hash table */
int hash_size(hashtable_type *table) {
    return ((hash_internal_type *)table)->entries;
}

/* Iterate throught the hash table retrieving values and keys */
hash_entry_type *hash_next(hashtable_type *void_table, hash_iterator_type **iterator) {
    hash_internal_type *table = (hash_internal_type *)void_table;
    hash_internal_iterator_type *it = 0; 
    key_value_type *entry = 0;

    /* if the iterator is null, allocate a new one */
    if (!*iterator) {
        gc_alloc_type(table->gc, 0, hash_iterator_def, iterator);
    }

    it = *(hash_internal_iterator_type **)iterator; 

    /* iterate through the list */
    do {
        
        /* because we're iterating between calls, entry may not be null here. */
        if (!it->entry) {
            it->entry = table->table[it->idx];
            it->idx++;
        }

        /* walk the chain */
        if (it->entry) {
            entry = it->entry;
            it->entry = it->entry->next;
            
            /* if we're at the end of the chain, find the next one. */
            return (hash_entry_type *)entry;
        }

    } while(it->idx < table->size);

    return 0;
}

/* output some useful stats about a hash table */
void hash_info(hashtable_type *void_table) {
    hash_internal_type *table = (hash_internal_type *)void_table;
    key_value_type *kv = 0;

    uint64_t max = 0;
    uint64_t current = 0;

    uint64_t active_chains = 0;

    printf(
        "Hash Info: Entries %lu Size %lu Load %f COW %i\n", table->entries, table->size,
        hash_load(table), table->copy_on_write);

    printf("\tHash Keys: ");
    for (int i = 0; i < table->size; i++) {
        kv = table->table[i];
        current = 0;

        while (kv) {
            /* save the previous value in the new
               table */
            printf(" %s", (char *)kv->key);
            current++;
            kv = kv->next;
        }

        if (current > 0) {
            active_chains++;
        }

        if (current > max) {
            max = current;
        }
    }

    printf(
        "\n\tLongest Chain %" PRIi64 " Active Chains %" PRIi64 " Average Chain %f\n", max,
        active_chains, (table->entries * 1.0) / active_chains);
}
