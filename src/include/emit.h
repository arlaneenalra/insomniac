#ifndef _EMIT_
#define _EMIT_

#include <string.h>

/* Mask off an 8 bit chunk of a number */
#define BYTE(i,b) ((((uint64_t)0xFF << (b *8)) & i ) >> (b * 8))


/* EMIT Macros */
#define EMIT(buf, op, size) {         \
    uint8_t code_ref[] = { op }; \
    buffer_write(buf, code_ref, size); \
    }

/* 64bit Literal value */
#define INT_64(i) BYTE(i,0), BYTE(i,1), BYTE(i,2), BYTE(i,3), \
        BYTE(i,4), BYTE(i,5), BYTE(i,6), BYTE(i,7)

#define LIT_FIXNUM(i) OP_LIT_FIXNUM, INT_64(i)

#define LIT_CHAR(i) OP_LIT_CHAR, BYTE(i,0), BYTE(i,1), BYTE(i,2), BYTE(i,3)

#define EMIT_LIT_FIXNUM(buf, i) EMIT(buf, LIT_FIXNUM(i), 9)
#define EMIT_LIT_CHAR(buf, i) EMIT(buf, LIT_CHAR(i), 5)

#define EMIT_LIT_STRING(buf, str) \
    {                             \
    vm_int length = strlen(str);  \
    EMIT(buf, OP_LIT_STRING, 1);  \
    EMIT(buf, INT_64(length), 8); \
    EMIT(buf, str, length);       \
}

#define EMIT_MAKE_SYMBOL(buf) EMIT(buf, OP_MAKE_SYMBOL, 1)

#define EMIT_LIT_EMPTY(buf) EMIT(buf, OP_LIT_EMPTY, 1)

#define EMIT_LIT_TRUE(buf) EMIT(buf, OP_LIT_TRUE, 1)
#define EMIT_LIT_FALSE(buf) EMIT(buf, OP_LIT_FALSE, 1)

#define EMIT_CONS(buf) EMIT(buf, OP_CONS, 1)

#define EMIT_MAKE_VECTOR(buf) EMIT(buf, OP_MAKE_VECTOR, 1)
#define EMIT_VECTOR_SET(buf) EMIT(buf, OP_VECTOR_SET, 1)
#define EMIT_VECTOR_REF(buf) EMIT(buf, OP_VECTOR_REF, 1)

#define EMIT_NOP(buf) EMIT(buf, OP_NOP, 1)
#define EMIT_SWAP(buf) EMIT(buf, OP_SWAP, 1)
#define EMIT_DUP_REF(buf) EMIT(buf, OP_DUP_REF, 1)


#endif
