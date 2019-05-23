#ifndef _ASM_
#define _ASM_

typedef struct debug_info {
    hashtable_type *files; 

} debug_info_type; 

/* Generate a compiled code ref given a string of
   insomniac asm */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref, debug_info_type **debug);

#endif
