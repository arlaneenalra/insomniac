;;; Test code designed to do loading of libraries
        "lib/stdlib.asm"
        slurp
        dup out
        asm

        "Assembled" out
        #\newline out

        dup
        out
        #\newline
        out
        
        call_in

        
        jmp loop

hi:
        "Hi There"
        out
        #\newline out
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
        