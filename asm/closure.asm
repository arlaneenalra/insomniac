;;; A simple proof that the vm can produce a closure

        "Closure test"
        out
        #\newline
        out

        10
        call gen_func

        s"ten_inc"
        bind

        50
        call gen_func

        s"fifty_inc"
        bind


        100000
loop:

        ;; Do increment from ten
        "ten "
        out
        
        s"ten_inc" @
        call_in

        out
        #\newline
        out

        ;; Do increment from fifty
        "fifty "
        out

        s"fifty_inc" @
        call_in

        out
        #\newline
        out

        
        1 -
        dup
        0 >
        jnf loop

        jmp exit

;;; bind passed in value to a and create
;;; a proc based on the current environment
        
gen_func:
        swap

        s"step"
        bind

        0
        s"i"
        bind
        
        proc func


        swap
        ret

;;; Increment and return the value
;;; of a
func:
        s"step" @
        s"i" @
        +
        dup
        
        s"i" !

        swap
        ret

exit:
        "Done"
        #\newline
        out
        out
        
        