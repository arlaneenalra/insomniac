#ifndef _ASM_INTERNAL_
#define _ASM_INTERNAL_

#include <insomniac.h>
#include <ops.h>
#include <emit.h>
#include <asm.h>

typedef enum {
    NUM_TOKEN,
    LABEL_TOKEN,

    FALSE_TOKEN,
    TRUE_TOKEN,

    OUT_TOKEN,
    NOP_TOKEN,
    DUP_TOKEN,
    SWAP_TOKEN,
    CONS_TOKEN,
    SYM_TOKEN,

    JNF_TOKEN,
    JMP_TOKEN,

    BAD_TOKEN,

    END_OF_FILE /* indicate an end of file */
} token_type;


/* return text of the matched string */
char * get_text(void *scanner);



#endif
