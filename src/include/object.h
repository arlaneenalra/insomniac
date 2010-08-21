#ifndef _OBJECT_
#define _OBJECT_

#include <inttypes.h>

typedef int8_t bool;
struct parser_core;

/* The types of cells that we can represent */
typedef enum {
    FIXNUM,
    FLOATNUM,
    IMAG,
    BOOL,
    CHAR,

    STRING,
    SYM,
    VECTOR,

    TUPLE,
    
    CHAIN /* internal type */
} object_type_enum;

typedef enum {
    RED,
    BLACK
} gc_mark_type;

struct object;

typedef	struct tuple {
    struct object *car;
    struct object *cdr;
} tuple_type;

typedef struct vector {
    uint64_t length;
    struct object **vector;
} vector_type;

typedef struct imaginary {
    long double real;
    long double imaginary;
} imaginary_type;

/* Define a structure to represent a memory cell */
typedef struct object {
    object_type_enum type;

    union {
	int64_t int_val;
	long double float_val; /* There should be a better way to do this */
	imaginary_type imaginary;

	char char_val; 
	char *string_val;

	vector_type vector;

	bool bool_val;

	tuple_type tuple;
    } value;
    
    /* Used by the garbage collector */
    struct object *next;
    gc_mark_type mark;
} object_type;


/* macros to extract various depths of car and cdr */

#define car(obj) obj->value.tuple.car
#define cdr(obj) obj->value.tuple.cdr

#define caar(obj) car(car(obj))
#define cadr(obj) car(cdr(obj))
#define cdar(obj) cdr(car(obj))
#define cddr(obj) cdr(cdr(obj))

#define caaar(obj) car(car(car(obj)))
#define caadr(obj) car(car(cdr(obj)))
#define cadar(obj) car(cdr(car(obj)))
#define caddr(obj) car(cdr(cdr(obj)))
#define cdaar(obj) cdr(car(car(obj)))
#define cdadr(obj) cdr(car(cdr(obj)))
#define cddar(obj) cdr(cdr(car(obj)))
#define cdddr(obj) cdr(cdr(cdr(obj)))

#endif
