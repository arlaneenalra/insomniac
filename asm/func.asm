;;; A simple example of calling a bound function

        proc newline
        s"newline"
        bind
        
        ;; Setup function calls
        100000
top:

        S"newline"
        call eval
        
        
        "Hi There"
        out

        "newline"
        sym
        dup
        call eval

        dup
        call eval
        call eval

        1 -
        dup
        0 =
        jnf exit
        
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
        