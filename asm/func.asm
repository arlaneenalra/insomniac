;;; A simple example of calling a bound function

        proc newline
        s"newline"
        bind
        
        ;; Setup function calls
        1000000

top:
        
        
        "Hi There "
        out
        
        dupout
        " " out
        
        1 -
        dup
        0 =
        jnf exit
        
        depth
        #\newline out out #\newline out

        proc top
        jin

        
        ;; ( sym -- )
eval:
        ;; Save the return address of another function
        swap
        @
        ret
        
        ;; ( -- )
newline:
        ;; Output a newline
        #\newline
        out
        ret


exit:
        "done"
        out
        
