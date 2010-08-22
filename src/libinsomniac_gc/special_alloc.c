#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <util.h>
#include <gc.h>


object_type *gc_alloc_vector(gc_core_type *gc, uint64_t size) {
    object_type *obj=0;
    
    obj=gc_alloc_object_type(gc, VECTOR);
    
    /* if we have a non-zero size, create an array of object pointer */
    if(size!=0) {
	obj->value.vector.vector=(object_type **)calloc(size, sizeof(object_type *));
    }

    obj->value.vector.length=size;
    
    return obj;
}
