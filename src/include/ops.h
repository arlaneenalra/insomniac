#ifndef _OPS_
#define _OPS_

/* Mask off an 8 bit chunk of a number */
#define BYTE(i,b) ((((uint64_t)0xFF << (b *8)) & i ) >> (b * 8))

/* Simple stack machine definition */

/* Single byte instructions */
#define OP_NOP 0x00 /* does nothing */

#define OP_LIT_EMPTY 0x01 /* Literal empty pair */

#define OP_LIT_FIXNUM 0x02 /* 64bit Integer Literal */

#define OP_CONS 0xFF /* Cons instruction */




/* EMIT Macros */

/* 64bit Literal value */
#define EMIT_LIT_FIXNUM(i) OP_LIT_FIXNUM, BYTE(i,0), BYTE(i,1), BYTE(i,2), BYTE(i,3), \
        BYTE(i,4), BYTE(i,5), BYTE(i,6), BYTE(i,7)

#define EMIT_LIT_EMPTY OP_LIT_EMPTY
#define EMIT_CONS OP_CONS
#define EMIT_NOP OP_NOP

#endif
