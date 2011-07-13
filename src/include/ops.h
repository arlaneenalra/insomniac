#ifndef _OPS_
#define _OPS_

/* Simple stack machine definition */

/* Single byte instructions */
typedef enum op {
    OP_NOP, /* does nothing */

    OP_LIT_EMPTY, /* Literal empty pair */
    OP_LIT_FIXNUM, /* 64bit Integer Literal */
    OP_LIT_CHAR, /* 32 bit character Literal */

    OP_LIT_TRUE, /* literals for true and false */
    OP_LIT_FALSE,

    OP_LIT_STRING, /* Define a string literal */
    OP_MAKE_SYMBOL, /* Take a string and turn it into a symbol */

    OP_CONS, /* Cons instruction */
    OP_CAR,  /* car and cdr */
    OP_CDR,
    OP_SET_CAR, /* set car and cdr */
    OP_SET_CDR,

    OP_MAKE_VECTOR, /* create an empty vector */
    OP_VECTOR_SET, /* set a column in a given vector */
    OP_VECTOR_REF, /* read the index into a vector an put it on the stack */

    /* jump operations Jumps are relative */
    OP_CALL, /* call the given target and leave return on stack */
    OP_PROC, /* create a closure for the given target */
    OP_JMP, /* just a jump */
    OP_JNF, /* jump if not false */
    OP_JIN, /* jump to closure on stack */

    OP_BIND, /* bind a value to a symbol */
    OP_SET,  /* set the value of a symbol */
    OP_READ, /* retrieve the value bound to a symbol */

    OP_SWAP, /* Swap the top two items on the stack */
    OP_ROT, /* Rotate the top three items on the stack */
    OP_DUP_REF, /* Duplicate the reference on the op of the stack */
    OP_DROP, /* drop the top item on the stack */
    OP_DEPTH, /* current stack depth */

    /* Math functions */
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV,
    OP_MOD,

    OP_NUMERIC_EQUAL,
    OP_NUMERIC_LT,
    OP_NUMERIC_GT,

    OP_NOT, /* invert a boolean value */

    OP_EQ, /* A simple equivalence operation */

    OP_OUTPUT, /* Outputs what ever is currently on the top of the stack */
    OP_GETC /* read a single character */
} op_type;





#endif
