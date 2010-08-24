#ifndef _PARSER_INTERNAL_
#define _PARSER_INTERNAL_

#include <util.h>
#include <parser.h>
#include <gc.h>

/* Used to tell add object that we are setting a car or cdr */
typedef enum {
    CAR,
    CDR
} setting_type_enum;

#define peek_scanner(parser) parser->scanner->scanner
#define peek_previous(parser) parser->scanner->previous

/* allocators */
scanner_stack_type *alloc_scanner(parser_core_type *parser);

void create_booleans(parser_core_type *parser);
void create_empty_list(parser_core_type *parser);
void create_eof_object(parser_core_type *parser);
void create_scanner(parser_core_type *parser);

object_type *cons(parser_core_type *parser, object_type *car, object_type *cdr);

void push_parse_state(parser_core_type *parser, FILE *fin);
void pop_parse_state(parser_core_type *parser);

/* Function definitions */
void set(parser_core_type *parser, setting_type_enum setting);
uint64_t list_length(parser_core_type *parser, object_type *list); /* Find the length of a passed in list */

object_type *symbol_sid(parser_core_type *parser, char *sym);

void add_object(parser_core_type *parser, object_type *obj);
void add_char(parser_core_type *parser, char *str);
void add_number(parser_core_type *parser, char *str);
void add_float(parser_core_type *parser, char *str);
void add_string(parser_core_type *parser, char *str);
void add_quote(parser_core_type *parser);
void add_vector(parser_core_type *parser);
void add_empty_vector(parser_core_type *parser);
void add_symbol(parser_core_type *parser, char *str);

void chain_state(parser_core_type *parser);
void push_state(parser_core_type *parser);
void pop_state(parser_core_type *parser);

void end_of_file(parser_core_type *parser);

char *get_text(void * scanner); /* return text from the lexer */

int parse_internal(parser_core_type *parser, void *scanner);

#endif
