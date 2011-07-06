;; A simple loop test
        100
loop:
        dup

        out
        #\space
        out

        1 -
        dup

        0 >
        jnf loop
        