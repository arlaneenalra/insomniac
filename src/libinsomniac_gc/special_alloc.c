#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <util.h>
#include <gc.h>

/* Allocate a vector */
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

/* Allocate a string as a copy of the passed in string */
object_type *gc_alloc_string(gc_core_type *gc, char *str) {
    object_type *obj=0;
    char *c=0;
    size_t len=0;
    
    len=strlen(str);

    c=(char *)malloc(len+1);
    
    if(!c) {
	fail("Unable to allocate string storage!");
    }

    strcpy(c, str);

    obj=gc_alloc_object_type(gc, STRING);
    obj->value.string_val=c;
	
    return obj;
}
