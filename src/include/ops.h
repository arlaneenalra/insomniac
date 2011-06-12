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
    OP_CONS, /* Cons instruction */

    OP_MAKE_VECTOR, /* create an empty vector */
    OP_VECTOR_SET, /* set a column in a given vector */
    OP_VECTOR_REF, /* read the index into a vector an put it on the stack */


    OP_SWAP, /* Swap the top two items on the stack */
    OP_DUP_REF /* Duplicate the reference on the op of the stack */

} op_type;





#endif
