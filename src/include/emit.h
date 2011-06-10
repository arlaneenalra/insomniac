#ifndef _EMIT_
#define _EMIT_

/* Mask off an 8 bit chunk of a number */
#define BYTE(i,b) ((((uint64_t)0xFF << (b *8)) & i ) >> (b * 8))


/* EMIT Macros */
#define EMIT(buf, op, size) {         \
    uint8_t code_ref[] = { op }; \
    buffer_write(buf, code_ref, size); \
    }

/* 64bit Literal value */
#define FIXNUM(i) OP_LIT_FIXNUM, BYTE(i,0), BYTE(i,1), BYTE(i,2), BYTE(i,3), \
        BYTE(i,4), BYTE(i,5), BYTE(i,6), BYTE(i,7)

#define EMIT_LIT_FIXNUM(buf, i) EMIT(buf, FIXNUM(i), 9)

#define EMIT_LIT_EMPTY(buf) EMIT(buf, OP_LIT_EMPTY, 1)

#define EMIT_LIT_TRUE(buf) EMIT(buf, OP_LIT_TRUE, 1)
#define EMIT_LIT_FALSE(buf) EMIT(buf, OP_LIT_FALSE, 1)

#define EMIT_CONS(buf) EMIT(buf, OP_CONS, 1)
#define EMIT_NOP(buf) EMIT(buf, OP_NOP, 1)



#endif
