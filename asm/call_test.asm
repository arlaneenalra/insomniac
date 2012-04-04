;;; Testing nested function calls
        proc jin_test
        s"jin_test" bind 

        continue handler

        ;; Bind a
        1
        S"a"
        bind

        ;; Should not work
        "Root b="
        out
        s"b" @
        out
        #\newline
        out

        proc func1
        s"func1"
        bind

        proc func2
        s"func2"
        bind

        ;;  call func1
        s"func1" @
        call_in
        
        ;; Should not work
        "Root b="
        out
        s"b" @
        out
        #\newline
        out

        s"jin_test" @
        jin

        jmp exit


jin_test:
        ;; testing jin
        "Hi there" 
        out
        #\newline
        out

        s"c" @
        out

        jmp exit



func1:
        "2"
        s"b"
        bind

        ;; This should work
        "Func1 a="
        out
        s"a" @
        out
        #\newline
        out

        ;; 
        "Func1 b="
        out
        s"b" @
        out
        #\newline
        out


        s"func2" @
        call_in

        ;; This should work
        "Func1 a="
        out
        s"a" @
        out
        #\newline
        out

        ;; ;; call into func2
        ;; call func2
        
        ret

func2:
        ;; Should work
        "Func2 a="
        out
        s"a" @
        out
        #\newline
        out

        ;; Change the value of a
        5 
        s"a" !

        ;; Should not work
        "Func2 b="
        out
        s"b" @
        out
        #\newline
        out

        ret

        ;; A basic exception handler
handler:

        #\newline
        dup
        out 
        out
        "Caught an Exception: "
        out

        dup
        car                     ;extract message
        
        out                     ;Output message
        #\newline
        out


        
        cdr                     ; Throw away the message
        dup                     ; duplicate our exception
        car                     ;Extract return

        swap

        cdr
        car                     ; Extract arguments

        "Arguments: "
        out
        #\newline
        out
        out                     ; Output the arguments
        #\newline
        out

        "BAD VALUE"             ; put something on the stack
        swap                    

        restore                 ;Turn this handler back on
        
        ret                     ;Return


        ;; Exit function
exit:
        "Done."
        out
        #\newline
        out
        
        
