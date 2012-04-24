
        1
        2
        3
        4
        5
        6

        call stack_dump

        jmp done

        ;; Output everything in the stack but the
        ;; return address
stack_dump:     
        "Dumping Stack"
        out
        #\newline
        out

stack_dump_loop:
        depth
        1 -
        0 =                     ; Depth + return makes 2
        jnf stack_dump_exit:

        swap                    ; Save return context

        out
        #\newline
        out

        jmp stack_dump_loop

stack_dump_exit:
        #\newline
        out
        "Empty"
        out

        ret


done:   
