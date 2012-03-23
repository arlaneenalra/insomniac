

;;; Check import
        "src/libinsomniac_io/libinsomniac_io.so"
        import

        drop
        s"io.lib"
        bind


        "src/libinsomniac_io/libinsomniac_io.so"
        import

        jmp loop

        drop
        s"io2.lib"
        bind


        "src/libinsomniac_io/libinsomniac_io.so"
        import
        drop
        s"io3.lib"
        bind




        s"io.lib" @
        dup out #\newline out

        s"io2.lib" @
        dup out #\newline out
        
        jmp loop

        eq

        s"io3.lib" @
        out #\newline out

        jnf good
        "io.lib and io2.lib are not equal"
        out
        #\newline
        out
good:   


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

;;        "WHOOP!"
;;        call say

        #\newline
        out

