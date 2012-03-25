#ifndef _UTF8_
#define _UTF8_

/* encode a single character as a utf8 string,
 the buffer is assumed to be 7 bytes in size */
void utf8_encode_char(char *output, vm_char character);

/* read a multibyte character from the input stream */
void utf8_read_char(vm_char *character);

/* determine how many bytes there are in a multibyte
   character based on the the head byte of the character */
int utf8_head_count_bytes(char c);

#endif
