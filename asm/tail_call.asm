;;; A simple test for tail call recursion, assuming all
;;; well.
        ()
        100000
        cons
        proc output
        cons
        
        call loop

        #\newline
        out
        "Stack depth at end:"
        out
        depth
        out
        #\newline
        out

        ()
        2000000
        cons
        proc output
        cons
        
        call loop

        #\newline
        out
        "Stack depth at end:"
        out
        depth
        out
        #\newline
        out

        
        jmp done

loop:
        swap                    ; Bring options to the top
        
        ;; Extract function and bind it to fun
        dup
        car
        S"fun"
        bind

        ;; Extract number and bind decrement it
        cdr
        car
        1 -

        ;; Save the number and output it
        dup

        S"fun"
        call eval

        ;; if the number is not 0, loop
        dup
        0 =
        jnf loop_exit

        ;; Reconstruct argument list
        ()
        swap
        cons
        
        S"fun"
        @
        cons

        swap
        
        proc loop
        jin


loop_exit:
        drop
        ret

        ;; Do a jin from a proc
eval:   swap
        @
        jin
        
        
        ;; Output a number on its own line
output:
        swap
        drop
        ;; "."
        ;; out
        ret

done:
        "Done."
        out