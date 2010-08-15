#ifndef _PARSER_INTERNAL_
#define _PARSER_INTERNAL_

#include <util.h>
#include <ast.h>

/* Used to tell add object that we are setting a car or cdr */
typedef enum {
    CAR,
    CDR
} setting_type_enum;

/* Function definitions */
void set(parser_core_type *interp, setting_type_enum setting);
int list_length(parser_core_type * interp, object_type *args); /* Find the length of a passed in list */

void add_object(parser_core_type *interp, object_type *obj);
void add_char(parser_core_type *interp, char *str);
void add_number(parser_core_type *interp, char *str);
void add_float(parser_core_type *interp, char *str);
void add_string(parser_core_type *interp, char *str);
void add_quote(parser_core_type *interp);
void add_vector(parser_core_type *interp);
void add_empty_vector(parser_core_type *interp);
void add_symbol(parser_core_type *interp, char *str);


object_type *create_string(parser_core_type *interp, char *str);
object_type *create_symbol(parser_core_type *interp, char *str);

void chain_state(parser_core_type *interp);
void push_state(parser_core_type *interp);
void pop_state(parser_core_type *interp);

void end_of_file(parser_core_type *interp);

char *get_text(void * scanner); /* return text from the lexer */

#endif
