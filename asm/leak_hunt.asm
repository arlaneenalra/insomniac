;;; Let's go hunting a leak
        5000000
loop:
        dup
        call output

        1 -

        dup
        0 >
        jnf loop

        jmp exit

output:
        swap
        "Num:"
        out
        out
        #\newline
        out

        ret
        
exit:
        "Done"
        out
