

;;; Check import
        "liblibinsomniac_io.so"
        import
        0 call_ext


;;; Test code designed to do loading of libraries
        "lib/stdlib.asm"
        slurp
        ;; dup out
        asm

        "Assembled" out
         #\newline out

        ;; dup
        ;; out
        ;; #\newline
        ;; out
        
        call_in
        
        jmp loop


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
        