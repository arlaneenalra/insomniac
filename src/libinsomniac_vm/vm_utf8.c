#include "vm_internal.h"
#include <strings.h>

#include <stdio.h> // for getc

#define BIT_MASK(i) ((uint32_t)0xFFFFFFFF >> (32 - i ))
#define NOT_MASK(i) ((uint32_t)0xFFFFFFFF << i)

#define UTF8_TAIL 0x80
#define UTF8_8TH_BIT 0x80
#define UTF8_HEAD(i) (0xFE << (6-i))

int utf8_head_count_bytes(char c) {
    int count = 0;

    while((c & UTF8_8TH_BIT ) !=0 && count < 6) {
        c <<=1;
        count++;
    }

    /* if there are no set bits, we have 1 byte */
    if (count == 0 ) {
        count = 1;
    }

    return count;
}

/* read a multibyte unicode character from stdin */
void utf8_read_char(vm_char *character) {
    char c;
    int bytes = 0;

    /* read in the first byte */
    c = getchar();

    bytes = utf8_head_count_bytes(c);

    /* a count of one means that the head is the 
       only byte */
    if(bytes == 1) {
        *character = c;
        return;
    }

    /* mask off the extraneous bits and pull in the blocks */
    c &= ~UTF8_HEAD(bytes);
    *character = c;

    /* read in the other utf8 bytes,
       start at one because we have already 
       read one byte. */
    for(int i = 1; i < bytes ; i++) {
        c = getchar();

        /* shift 6 bits left */
        *character <<= 6;
        /* mask of the utf8 tag bits and 
           or the data bits into the character */
        *character |= (c & BIT_MASK(6));
    }
}

/* encode a raw unicode character to utf8 */
void utf8_encode_char(char *output, vm_char character) {
    bzero(output, 7);
    
    /* walk through each of the possible mappings */
    if(!(character & NOT_MASK(7))) {
        output[0]=(uint8_t)(character & BIT_MASK(7));

    } else if(!(character & NOT_MASK(11))) {
        output[1]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;
        
        output[0]=UTF8_HEAD(1) | (uint8_t)character;

    } else if(!(character & NOT_MASK(16))) {
        output[2]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[1]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;
        
        output[0]=UTF8_HEAD(2) | (uint8_t)character;

    } else if(!(character & NOT_MASK(21))) {
        output[3]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[2]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[1]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;
        
        output[0]=UTF8_HEAD(3) | (uint8_t)character;

    } else if(!(character & NOT_MASK(26))) {
        output[4]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[3]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[2]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[1]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;
        
        output[0]=UTF8_HEAD(4) | (uint8_t)character;

    } else if(!(character & NOT_MASK(31))) {
        output[5]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[4]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[3]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[2]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;

        output[1]=UTF8_TAIL | (uint8_t)(character & BIT_MASK(6));
        character >>= 6;
        
        output[0]=UTF8_HEAD(5) | (uint8_t)character;
    }
}
