#ifndef _ASM_
#define _ASM_

typedef struct debug_state debug_state_type;

struct debug_state {
    char *file;
    vm_int line;
    vm_int column;
  
    vm_int start_addr;
    debug_state_type *next;
};

typedef struct debug_info {
    hashtable_type *files; 

    debug_state_type *head;
    debug_state_type *tail;

} debug_info_type; 

/* Generate a compiled code ref given a string of
   insomniac asm */
size_t asm_string(gc_type *gc, char *str, uint8_t **code_ref, debug_info_type **debug);

#endif
