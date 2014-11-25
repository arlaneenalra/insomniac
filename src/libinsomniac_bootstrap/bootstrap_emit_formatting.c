#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

/* Add a new line to the output buffer stream */
void emit_newline(buffer_type *buf) {
    char *newline = "\n";
    buffer_write(buf, (uint8_t *)newline, strlen(newline));
}

/* Add indention to ASM */
void emit_indent(buffer_type *buf) {
    char *indent = "        ";
    buffer_write(buf, (uint8_t *)indent, 8);
}

/* Write a coment into the instruction buffer */
void emit_comment(buffer_type *buf, char *str) {
    buffer_write(buf, (uint8_t *)";; ", 3);
    buffer_write(buf, (uint8_t *)str, strlen(str));
    emit_newline(buf);
}



