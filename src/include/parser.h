#ifndef _PARSER_
#define _PARSER_

#include <stdio.h>
#include <object.h>
#include <gc.h>

/* stores the two global booleans */
typedef struct bool_global {
    object_type *true;
    object_type *false;
} bool_global_type;


/* Stores symbols for look up latter. */
typedef struct symbol_table {
    uint64_t sid; /* id for the next symbol */
    object_type *list; /* list of all defined symbols */
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

    /* pointer to the gc attached to this parser */
    gc_core_type *gc;

} parser_core_type;

/* Some useful macros */
#define false(parser) parser->boolean.false
#define true(parser) parser->boolean.true

parser_core_type *parser_create(gc_core_type *gc);
void parser_destroy(parser_core_type *parser);

object_type *parse(parser_core_type *parser, FILE *in);

void output(parser_core_type *parser, object_type *obj);
void output_stream(parser_core_type *parser, object_type *obj, FILE *fout);

#endif
