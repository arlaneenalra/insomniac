;;; A simple example of calling a bound function

        ;; Setup function calls
        call newline
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
        
save_proc:                      ; ( ret-func, ret-caller )
        swap                    ; ( ret-caller, ret-func )
        ret

        ;; outputs a newline
newline:
        call save_proc           ; save return as closure
        
        ;; Output a newline
        #\newline
        out
        ret


exit:
        "done"
        out
        