#ifndef _ASM_
#define _ASM_


/* Generate a compiled code ref given a string of 
   insomniac asm */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref);


#endif
