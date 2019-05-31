#ifndef _ASM_INTERNAL_
#define _ASM_INTERNAL_

#include <insomniac.h>

#include <asm.h>
#include <emit.h>
#include <ops.h>

/* custom tokens required by asm that are not ops */
#define END_OF_FILE OP_MAX_INS + 1
#define LABEL_TOKEN OP_MAX_INS + 2

#define STRING_START_TOKEN OP_MAX_INS + 3
#define STRING_END_TOKEN OP_MAX_INS + 4
#define SYMBOL_START_TOKEN OP_MAX_INS + 5

#define DIRECTIVE_FILE OP_MAX_INS + 6

typedef struct jump jump_type;

/* Used to track jumps for latter rewriting */
struct jump {
    char *label;
    vm_int addr;
    vm_int lineno;

    jump_type *next;
};


/* Return text of the matched string */
char *get_text(void *scanner);

gc_type_def get_debug_info_def(gc_type *gc);
gc_type_def get_debug_state_def(gc_type *gc);

#endif
