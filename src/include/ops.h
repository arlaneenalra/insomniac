#ifndef _OPS_
#define _OPS_

/* Mask off an 8 bit chunk of a number */
#define BYTE(i,b) ((((uint64_t)0xFF << (b *8)) & i ) >> (b * 8))

/* Simple stack machine definition */

/* Single byte instructions */
typedef enum op {
    OP_NOP, /* does nothing */

    OP_LIT_EMPTY, /* Literal empty pair */
    OP_LIT_FIXNUM, /* 64bit Integer Literal */

    OP_LIT_TRUE, /* literals for true and false */
    OP_LIT_FALSE,

    OP_LIT_STRING, /* Define a string literal */

    OP_CONS /* Cons instruction */
} op_type;




/* EMIT Macros */

/* 64bit Literal value */
#define EMIT_LIT_FIXNUM(i) OP_LIT_FIXNUM, BYTE(i,0), BYTE(i,1), BYTE(i,2), BYTE(i,3), \
        BYTE(i,4), BYTE(i,5), BYTE(i,6), BYTE(i,7)

#define EMIT_LIT_EMPTY OP_LIT_EMPTY

#define EMIT_LIT_TRUE OP_LIT_TRUE
#define EMIT_LIT_FALSE OP_LIT_FALSE

#define EMIT_CONS OP_CONS
#define EMIT_NOP OP_NOP

#endif
