#ifndef _PARSER_
#define _PARSER_

#include <object.h>

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


extern parser_core_type *parser_create();
extern void parser_destroy(parser_core_type *parser);

#endif
