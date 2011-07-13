;;; A simple example of calling a bound function

        ;; Setup function calls
        proc newline
        "newline"
        sym
        bind


        "newline"
        sym
        dup
        call eval
        
        
        "Hi There"
        out

        dup
        call eval

        dup
        call eval

        
        jmp exit

        
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
        