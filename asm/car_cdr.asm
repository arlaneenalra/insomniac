f;;; A simple test for car, cdr, set-car, and set-cdr
        100
        0
        cons                    ; setup working pair
loop:   
        dup
        dup
        car                     ; extract counter [ a, (),() ]

        swap                    ; [(), a, ()]

        cdr                     ; extract max [d, a, ()]

        >                       ; check for done
        jnf done


        ;; Increment counter part of pair
        dup
        car

        1 +                     
        set-car

        dup
        out
        #\newline
        out

        jmp loop

done:
        #\newline
        out
        "Done."
        out

stack:  
        "Dumping Stack"
        out
        #\newline
        out

stack_dump:
        depth
        0 =
        jnf done2

        out
        #\newline
        out

        jmp stack_dump

done2:  


