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


    gc_unregister_root(gc, (void**)&table);
    
    return (hashtable_type *)table;
}

