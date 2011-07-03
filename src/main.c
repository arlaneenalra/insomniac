#include <stdio.h>
#include <assert.h>

#include <insomniac.h>
#include <ops.h>

#include <locale.h>


void assemble_work(buffer_type *buf) {
    char char_buf[100];

    EMIT_LIT_FALSE(buf);
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
    for(int i=0; i<30;i++) {
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

        EMIT_LIT_FIXNUM(buf, 10);
        EMIT_MAKE_VECTOR(buf);

        for(int y = 0; y < 10 ; y++) {
            EMIT_DUP_REF(buf);
            EMIT_LIT_FIXNUM(buf, y);

            sprintf(char_buf, "Hi%i",y);

            EMIT_LIT_STRING(buf, char_buf);

            EMIT_MAKE_SYMBOL(buf);
            EMIT_CONS(buf);
            EMIT_LIT_FIXNUM(buf, y);
            EMIT_VECTOR_SET(buf);
        }

        EMIT_DUP_REF(buf);
        EMIT_LIT_FIXNUM(buf, 1);
        EMIT_VECTOR_REF(buf);
    }
    
    /* output everything on the statck */
    EMIT_DUP_REF(buf); /* 1 byte */
    EMIT_OUTPUT(buf); /* 1 byte */
    EMIT_JNF(buf, -11); /* 9 bytes total */
    
    EMIT_LIT_STRING(buf, "\nDone!\n");
    EMIT_OUTPUT(buf);
    
    EMIT_LIT_STRING(buf, "Testing Second Jump.");
    /* EMIT_JMP(buf, 1); /\* jump over this output *\/ */
    EMIT_OUTPUT(buf);
    
}

int main(int argc, char**argv) {
    gc_type *gc = gc_create(sizeof(object_type));
    vm_type *vm = 0; 

    size_t length=0;
    size_t written=0;
    buffer_type *buf = 0;
    uint8_t *code_ref = 0;
    hashtable_type *hash = 0;

    /* needed to setup locale aware printf . . . 
       I need to do a great deal more research here */
    setlocale(LC_ALL, "");
    printf("'%lc' lambda\n", 0x03BB);

    /* make this a root to the garbage collector */
    gc_register_root(gc, &buf);
    gc_register_root(gc, &vm);
    gc_register_root(gc, (void **)&code_ref);
    gc_register_root(gc, &hash);

    vm = vm_create(gc);

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

    /* vm_output_object(stdout, vm_eval(vm, length, code_ref)); */
    vm_eval(vm, length, code_ref);
 
    printf("\n");

    /* vm_reset(vm); */

    /* gc_stats(gc); */
    /* gc_sweep(gc); */
    /* gc_stats(gc); */
    /* printf("Evaluating\n"); */

    /* vm_output_object(stdout, vm_eval(vm, length, code_ref)); */
    /* printf("\n"); */

    /* vm_reset(vm); */

    /* gc_stats(gc); */
    /* gc_sweep(gc); */
    /* gc_stats(gc); */
    
    vm_destroy(vm);

    gc_unregister_root(gc, &hash);
    gc_unregister_root(gc, (void **)&code_ref);
    gc_unregister_root(gc, &vm);
    gc_unregister_root(gc, &buf);

    gc_destroy(gc);

    return 0;
}
