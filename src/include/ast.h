#ifndef _AST_
#define _AST_

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
    VECTOR,
    TUPLE,
    SYM,
    PORT,
    
    CHAIN /* internal type */
} object_type_enum;

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

    struct object *next;
} object_type;

typedef struct bool_global {
    object_type *true;
    object_type *false;
} bool_global_type;


/* Stores symbols for look up latter. */
typedef struct symbol_table {
    object_type *list;
} symbol_table_type;

/* used to keep track of a stack of lexers */
typedef struct scanner_stack {
    void * scanner;
    struct scanner_stack *previous;
} scanner_stack_type;

/* Values that are required for an instance of the parse
   to function properly */

typedef struct parser_core {
    bool error; /* An error has occured */
    bool parsing; /* Is the parser running */
    
    /* Instances of #t and #f */
    bool_global_type boolean;
    
    /* The empty list */
    object_type *empty_list;
    object_type *quote;
    object_type *eof_object;


    /* Object to be attached to the object graph */
    object_type *added;

    /* Object we are currently working on */
    object_type *current;


    /* Used by the parser to generate lists */
    object_type *state_stack;
    
    /* List of all symbols in the system */
    symbol_table_type symbols;

    /* an instance of the parser/lexer */
    scanner_stack_type *scanner;     
} parser_core_type;


extern parser_core_type *create_parser();
extern void cleanup_parser(parser_core_type *parser);

#endif
