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


    gc_unregister_root(gc, (void**)&table);
    
    return (hashtable_type *)table;
}



/* resize/allocagte hashtable array */
void hash_resize(hash_internal_type *table, size_t size) {
    key_value_type *new_table = 0;

    /* do we have an existing table ? */
    if(!table->table) {
        table->table = gc_alloc_pointer_array(table->gc,
                                              0,
                                              size);
        return;
    }

    gc_register_root(table->gc, (void **)&new_table);

    /* TODO: Add in resizing code here */

    gc_unregister_root(table->gc, (void **)&new_table);
}
