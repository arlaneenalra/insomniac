;; A simple loop test
        ()
        100
loop:
        cons

        dup
        car
        
        1 -
        dup

        0 >
        jnf loop

        drop

        ;;  duplicate the list we just created
        dup

;; Dump a list
list_dump:
        dup
        () eq
        jnf done_list_dump

        dup

        car
        out
        #\space
        out

        cdr

        jmp list_dump

done_list_dump:
        ;;  get rid of the () we have on the stack
        drop
;; output everything on the stack        
        #\newline
        out

        "Dumping Stack"
        out
        #\newline
        out

stack_dump:
        depth
        0 =
        jnf done

        out
        #\newline
        out

        jmp stack_dump
        
done:
        #\newline
        out
        "Done."
        out
        #\newline
        out

     
        