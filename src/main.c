#include <stdio.h>
#include <assert.h>

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
    printf("Bytes written: %zu\n", written);
    printf("Evaluating\n");

    vm_eval(vm, written, code_ref);
    printf("\n");

    gc_unregister_root(gc, (void **)&code_ref);
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = 0; 



    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");
    printf("'%lc' lambda\n", 0x03BB);

    /* make this a root to the garbage collector */
    gc_register_root(gc, &vm);

    vm = vm_create(gc);

    gc_stats(gc);

    eval_string(vm, gc, "#f out #\\n out 2 1 dup cons cons out #\\newline out");

    eval_string(vm, gc, " \"Hi\" out #\\space out \"\" out");

    vm_destroy(vm);

    gc_unregister_root(gc, &vm);

    gc_destroy(gc);

    return 0;
}
