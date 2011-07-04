#ifndef _ASM_INTERNAL_
#define _ASM_INTERNAL_

#include <insomniac.h>
#include <ops.h>
#include <emit.h>
#include <asm.h>

/* custom tokens required by asm that are not ops */
#define END_OF_FILE 256
#define LABEL_TOKEN 257

#define STRING_START_TOKEN 258
#define STRING_END_TOKEN 259

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
