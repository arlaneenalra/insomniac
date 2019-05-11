#include "bootstrap_internal.h"

#include <string.h>

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

/* Write debugging information */
void emit_debug(buffer_type *buf, ins_node_type *node) {
    char num_buf[12];
    int written;
    
    /* Convert the line number to a string. */
    written = snprintf(num_buf, 12, "%i", node->line);
    buffer_write(buf, (uint8_t *)";;;; Line: ", 11);
    buffer_write(buf, (uint8_t *)num_buf, written);

    /* Convert the column number to a string. */
    written = snprintf(num_buf, 12, "%i", node->column);
    buffer_write(buf, (uint8_t *)" Column: ", 9);    
    buffer_write(buf, (uint8_t *)num_buf, written);

    /* Write out the file. */
    buffer_write(buf, (uint8_t *)" File: ", 7);
    buffer_write(buf, (uint8_t *)node->file, strlen(node->file));
    
    emit_newline(buf);
}
