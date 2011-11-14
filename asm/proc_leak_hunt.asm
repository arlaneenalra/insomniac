;;; Looking for a leak in proc
        10000

        proc output
        s"output"
        bind
loop:
        
        ;; s"output" @
        proc output
        call_in
        
        1 -
        dup
        0 >
        jnf do_loop
        jmp exit
        
do_loop:        
        proc loop
        jin


output:
        swap

        dup
        out
        #\newline
        out
        
        swap
        ret
exit:
        "Done."
        #\newline out out