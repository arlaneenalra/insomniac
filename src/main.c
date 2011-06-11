#include <stdio.h>

#include <insomniac.h>
#include <ops.h>

#include <locale.h>


void assemble_work(buffer_type *buf) {
    EMIT_LIT_EMPTY(buf);

    /* create a fix num */
    for(int i=0; i<10;i++) {
        EMIT_LIT_FIXNUM(buf, i);
        EMIT_CONS(buf);
        EMIT_LIT_TRUE(buf);
        EMIT_CONS(buf);
    }

    EMIT_LIT_STRING(buf, "END");

    /* create a fix num */
    for(int i=0; i<100;i++) {
        EMIT_LIT_FIXNUM(buf, i);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x03BB);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x30CA);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x01D5);
        EMIT_CONS(buf);
        EMIT_LIT_CHAR(buf, 0x1D2C);
        EMIT_CONS(buf);
        EMIT_LIT_STRING(buf, "Hi there!");
    }

    EMIT_CONS(buf);
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = vm_create(gc);

    size_t length=0;
    size_t written=0;
    buffer_type *buf = 0;
    uint8_t *code_ref = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");
    printf("'%lc' lambda\n", 0x03BB);

    /* make this a root to the garbage collector */
    gc_register_root(gc, &buf);
    gc_register_root(gc, (void **)&code_ref); 

    buf = buffer_create(gc);

    assemble_work(buf);

    length = buffer_size(buf);
    printf("Size %zu\n", length);
    gc_stats(gc);

    /* create a code ref */
    code_ref = gc_alloc(gc, 0, length);
    written = buffer_read(buf, &code_ref, length);
    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);

    printf("Evaluating\n");

    vm_output_object(stdout, vm_eval(vm, length, code_ref));
    printf("\n");

    vm_reset(vm);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);
    printf("Evaluating\n");

    vm_output_object(stdout, vm_eval(vm, length, code_ref));
    printf("\n");

    vm_reset(vm);

    gc_stats(gc);
    gc_sweep(gc);
    gc_stats(gc);
    
    gc_unregister_root(gc, (void **)&code_ref);
    gc_unregister_root(gc, &buf);

    vm_destroy(vm);
    gc_destroy(gc);

    return 0;
}
