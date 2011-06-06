#ifndef _OPS_
#define _OPS_

/* Mask off an 8 bit chunk of a number */
#define BYTE(i,b) (((0xFF << (b *8)) & i ) >> (b * 8))

/* Simple stack machine definition */

/* Single byte instructions */
#define OP_NOP 0x00 /* does nothing */


#define OP_LITI 0x01 /* 64bit Integer Literal */


/* Single argument literals */

/* /\* 64bit Literal value *\/ */
/* #define EMITLIT(i) 0x01, BYTE(i,0), BYTE(i,1), BYTE(i,2), BYTE(i,3) \ */
/*         BYTE(i,4), BYTE(i,5), BYTE(i,6), BYTE(i,7) */


#endif
