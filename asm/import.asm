

;;; Check import
        "src/libinsomniac_io/liblibinsomniac_io.so"
        import
        s"io.lib"
        bind

        call hi
        call hi


;;; Test code designed to do loading of libraries
        "lib/stdlib.asm"
        slurp
        ;; dup out
        asm

        call_in

        "Assembled"
        call say
        
        #\newline
        call say


        ;; dup
        ;; out
        ;; #\newline
        ;; out
        
        
        jmp loop


hi:
        s"io.lib" @
        0 call_ext
        ret

say:
        swap
        s"io.lib" @
        1 call_ext
        ret


loop:
        out

        #\newline
        out

        depth

        0 >
        jnf loop

        #\newline
        out
        #\newline
        out

        "Done."
        out
        #\newline
        out

        "WHOOP!"
        call say