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
    buffer_write(buf, (uint8_t *)str, length);  \
}

/* core of all jump operations */
#define JMP(type, target) type, INT_64(target)
#define EMIT_JMP_BODY(buf, type, target) \
    EMIT(buf, JMP(type, target), 9)

#define EMIT_JMP(buf, target) EMIT_JMP_BODY(buf, OP_JMP, target)
#define EMIT_JNF(buf, target) EMIT_JMP_BODY(buf, OP_JMP, target)

#endif
