
#include <stdio.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <insomniac.h>
#include <ops.h>
#include <emit.h>

#include <asm.h>

#include <locale.h>

void eval_string(vm_type *vm, gc_type *gc, char *str) {
    size_t written=0;
    uint8_t *code_ref = 0;

    gc_register_root(gc, (void **)&code_ref);

    /* assemble a simple command */
    written = asm_string(gc, str, &code_ref);

    vm_eval(vm, written, code_ref);

    gc_unregister_root(gc, (void **)&code_ref);
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = 0; 
    char *code_str = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");

    /* check for file argument */
    if(argc < 2) {
        printf("Usage: %s <file.asm>\n", argv[0]);
        exit(-1);
    }

    /* make this a root to the garbage collector */
    gc_register_root(gc, &vm);
    gc_register_root(gc, (void **)&code_str);

    vm_create(gc, &vm);

    /* load and eval */
    eval_string(vm, gc, " \"Insomniac VM\" out #\\newline out");
    (void)buffer_load_string(gc, argv[1], &code_str);
    eval_string(vm, gc, code_str);

    vm_reset(vm);

    /* Shut everything down */
    vm_destroy(vm);
    gc_unregister_root(gc, &vm);
    gc_unregister_root(gc, (void **)&code_str);
    gc_destroy(gc);

    return 0;
}
