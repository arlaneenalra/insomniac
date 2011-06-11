#ifndef _UTF8_
#define _UTF8_

/* encode a single character as a utf8 string,
 the buffer is assumed to be 7 bytes in size */
void utf8_encode_char(char *output, vm_char character);



#endif
