#include "vm_instructions_internal.h"

#include "vm_math.h"
#include "vm_types.h"

/* Math operations */
NUMERIC_OP(op_add, +)
NUMERIC_OP(op_sub, -)
NUMERIC_OP(op_mul, *)
NUMERIC_OP(op_div, /)
NUMERIC_OP(op_mod, %)

NUMERIC_LOGIC(op_numeric_equal, ==)
NUMERIC_LOGIC(op_numeric_lt, <)
NUMERIC_LOGIC(op_numeric_gt, >)

/* Identifiy the type of an object */
TYPE_OP(op_is_fixnum, TYPE_TEST(FIXNUM))
TYPE_OP(op_is_bool, TYPE_TEST(BOOL))
TYPE_OP(op_is_char, TYPE_TEST(CHAR))
TYPE_OP(op_is_string, TYPE_TEST(STRING))
TYPE_OP(op_is_symbol, TYPE_TEST(SYMBOL))
TYPE_OP(op_is_vector, TYPE_TEST(VECTOR))
TYPE_OP(op_is_byte_vector, TYPE_TEST(BYTE_VECTOR))
TYPE_OP(op_is_record, TYPE_TEST(RECORD))
TYPE_OP(op_is_pair, TYPE_TEST(PAIR))
TYPE_OP(op_is_empty, TYPE_TEST(EMPTY))
TYPE_OP(op_is_closure, TYPE_TEST(CLOSURE))
TYPE_OP(op_is_library, TYPE_TEST(LIBRARY))
TYPE_OP(
    op_is_self, (TYPE_TEST(FIXNUM) || TYPE_TEST(BOOL) || TYPE_TEST(CHAR) ||
                 TYPE_TEST(STRING) || TYPE_TEST(VECTOR) || TYPE_TEST(BYTE_VECTOR)))

/* setup of instructions in given vm instance */
void setup_instructions(vm_internal_type *vm) {

    vm->ops[OP_LIT_FIXNUM] = &op_lit_64bit;
    vm->ops[OP_LIT_EMPTY] = &op_lit_empty;
    vm->ops[OP_LIT_CHAR] = &op_lit_char;
    vm->ops[OP_LIT_STRING] = &op_lit_string;
    vm->ops[OP_LIT_SYMBOL] = &op_lit_symbol;
    vm->ops[OP_MAKE_SYMBOL] = &op_make_symbol;
    vm->ops[OP_LIT_TRUE] = &op_lit_true;
    vm->ops[OP_LIT_FALSE] = &op_lit_false;

    vm->ops[OP_MAKE_VECTOR] = &op_make_vector;
    vm->ops[OP_MAKE_BYTE_VECTOR] = &op_make_byte_vector;
    vm->ops[OP_MAKE_RECORD] = &op_make_record;
    vm->ops[OP_INDEX_SET] = &op_index_set;
    vm->ops[OP_INDEX_REF] = &op_index_ref;
    vm->ops[OP_VECTOR_LENGTH] = &op_vector_length;
    vm->ops[OP_STRING_BYTE_VECTOR] = &op_string_byte_vector;
    vm->ops[OP_BYTE_VECTOR_STRING] = &op_byte_vector_string;

    vm->ops[OP_CONS] = &op_cons;
    vm->ops[OP_CAR] = &op_car;
    vm->ops[OP_CDR] = &op_cdr;
    vm->ops[OP_SET_CAR] = &op_set_car;
    vm->ops[OP_SET_CDR] = &op_set_cdr;

    vm->ops[OP_BIND] = &op_bind;
    vm->ops[OP_SET] = &op_set;
    vm->ops[OP_READ] = &op_read;

    /* stack operations */
    vm->ops[OP_SWAP] = &op_swap;
    vm->ops[OP_ROT] = &op_rot;
    vm->ops[OP_DUP_REF] = &op_dup_ref;
    vm->ops[OP_DROP] = &op_drop;
    vm->ops[OP_DEPTH] = &op_depth;

    vm->ops[OP_OUTPUT] = &op_output;
    vm->ops[OP_FD_READ] = &op_fd_read;
    vm->ops[OP_FD_WRITE] = &op_fd_write;
    vm->ops[OP_OPEN] = &op_open;
    vm->ops[OP_CLOSE] = &op_close;
    vm->ops[OP_SLURP] = &op_slurp;
    vm->ops[OP_ASM] = &op_asm;

    /* math operatins */
    vm->ops[OP_ADD] = &op_add;
    vm->ops[OP_SUB] = &op_sub;
    vm->ops[OP_MUL] = &op_mul;
    vm->ops[OP_DIV] = &op_div;
    vm->ops[OP_MOD] = &op_mod;

    /* numeric logical operations */
    vm->ops[OP_NUMERIC_EQUAL] = &op_numeric_equal;
    vm->ops[OP_NUMERIC_LT] = &op_numeric_lt;
    vm->ops[OP_NUMERIC_GT] = &op_numeric_gt;

    /* Logical operations */
    vm->ops[OP_NOT] = &op_not;
    vm->ops[OP_EQ] = &op_eq;

    /* jump operations */
    vm->ops[OP_JMP] = &op_jmp;
    vm->ops[OP_JNF] = &op_jnf;

    /* procedure operations */
    vm->ops[OP_CALL] = &op_call;
    vm->ops[OP_ADOPT] = &op_adopt;
    vm->ops[OP_PROC] = &op_proc;
    vm->ops[OP_RET] = &op_ret;         /* return */
    vm->ops[OP_JIN] = &op_jin;         /* jump indirect */
    vm->ops[OP_CALL_IN] = &op_call_in; /* call indirect */
    vm->ops[OP_TAIL_CALL_IN] = &op_tail_call_in;

    vm->ops[OP_IMPORT] = &op_import;     /* dlopen a dll */
    vm->ops[OP_CALL_EXT] = &op_call_ext; /* call an imported function */

    /* Exception Handline */
    vm->ops[OP_CONTINUE] = &op_continue;
    vm->ops[OP_RESTORE] = &op_restore;

    vm->ops[OP_SET_EXIT] = &op_set_exit;

    /* type testing operations */
    vm->ops[OP_IS_FIXNUM] = &op_is_fixnum;
    vm->ops[OP_IS_BOOL] = &op_is_bool;
    vm->ops[OP_IS_CHAR] = &op_is_char;
    vm->ops[OP_IS_STRING] = &op_is_string;
    vm->ops[OP_IS_SYMBOL] = &op_is_symbol;
    vm->ops[OP_IS_VECTOR] = &op_is_vector;
    vm->ops[OP_IS_BYTE_VECTOR] = &op_is_byte_vector;
    vm->ops[OP_IS_RECORD] = &op_is_record;
    vm->ops[OP_IS_PAIR] = &op_is_pair;
    vm->ops[OP_IS_EMPTY] = &op_is_empty;
    vm->ops[OP_IS_CLOSURE] = &op_is_closure;
    vm->ops[OP_IS_SELF] = &op_is_self;

    /* internals operations */
    vm->ops[OP_GC_STATS] = &op_gc_stats;
}
