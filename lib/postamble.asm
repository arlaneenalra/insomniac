
;;; Postamble code
;;; This is what actually causes user code to run.
;;; expects ( user-code -- )

        #\newline out
        #\newline out
        "-----------------------------------" out
        #\newline out
        
        "Returned: " out
        out
        #\newline out

        call stack_dump

        ;; Exit cleanly
        jmp exit

        ;; In the event of an error, dump the stack
panic:
        #\newline dup out out
        "Something has gone wrong!" out
        #\newline dup out out

        call stack_dump
        jmp exit

        ;; Output everything in the stack but the
        ;; return address
stack_dump:     
        "Dumping Stack"
        out
        #\newline
        out

        () s"stack-save" bind

stack_dump_loop:
        depth
        1 -
        0 =                     ; Depth + return makes 2
        jnf stack_dump_exit

        swap                    ; Save return context

        ; save stack 
        dup s"stack-save" @ swap cons s"stack-save" !

        out
        #\newline
        out

        jmp stack_dump_loop

stack_dump_exit:
        #\newline
        out
        "Empty"
        out
        #\newline
        out

        ; restore stack
        s"stack-save" @

stack_dump_restore:
        dup null?
        jnf stack_dump_done

        dup car ;; push the next stack value back onto the stack

        rot ;; push the restored value to blow the list and return
        
        cdr ;; move to the next saved stack entry

        jmp stack_dump_restore

stack_dump_done:
        drop ;; drop the empty list

        ret

exit:
        
