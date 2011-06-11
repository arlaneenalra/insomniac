#include "vm_internal.h"
#include <strings.h>

#define BIT_MASK(i) ((uint32_t)0xFFFFFFFF >> (32 - i ))
#define NOT_MASK(i) ((uint32_t)0xFFFFFFFF << i)

#define UTF8_TAIL 0x80
#define UTF8_HEAD(i) (0xFE << (6-i))


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
