        ;; Attempt to generate a few Fibonacci numbers


        1 dup "a" sym bind out
        #\space out
        1 dup "b" sym bind out
        #\space out

        40                      ; Number to generate
fib:
        "b" sym @
        dup
        "a" sym @
        +
        dup out
        #\space out
        "b" sym !
        "a" sym !

        1 - dup                 ; Loop until 0
        0 >
        jnf fib                 