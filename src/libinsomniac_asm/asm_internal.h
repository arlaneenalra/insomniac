#ifndef _ASM_INTERNAL_
#define _ASM_INTERNAL_

#include <insomniac.h>
#include <ops.h>
#include <emit.h>
#include <asm.h>

/* custom tokens required by asm that are not ops */
#define END_OF_FILE OP_MAX_INS+1
#define LABEL_TOKEN OP_MAX_INS+2

#define STRING_START_TOKEN OP_MAX_INS+3
#define STRING_END_TOKEN OP_MAX_INS+4
#define SYMBOL_START_TOKEN OP_MAX_INS+5

typedef struct jump jump_type;

/* Used to track jumps for latter rewriting */
struct jump {
    char *label;
    vm_int addr;

    jump_type *next;
};

/* return text of the matched string */
char * get_text(void *scanner);



#endif
