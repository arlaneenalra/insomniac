;;; Creating an evnironment object that can be passed around

        ;; Setup the empty environment
        proc root-env
        s" root_env" bind

        ;; Funciton to make child environments
        proc make-child
        s" make_child" bind

        proc eval
        s" eval" bind

        ;; call entry point to create a child environment
        call start

        ;; ( proc ret -- ) 
root-env:
        " - In Root - " out
        swap
        jin

        ;; execute in root-env to create a child of that environment
        ;; and return it
make-child:

        proc root-env

        swap
        ret

        ;; actually run code in an environment
eval:
        swap
        ret
        
start:
        1 s"B" bind

        ;; create our own child environment
        s" make_child" @
        s" root_env" @
        call_in

        s"my-env" bind

        ;; create our own child environment
        s" make_child" @
        s" root_env" @
        call_in

        s"my-env2" bind
        
        
        " - Created child environments - "
        out
        #\newline
        out

        ;; bind a value in the new environment
        proc test-env-bind
        s"my-env" @
        s" eval" @
        call_in

        
        ;; bind a value in the new environment
        proc test-env-bind2
        s"my-env2" @
        s" eval" @
        call_in

        #\newline out

        "Reading Environment!"
        out
        #\newline out

        proc test-env-read
        s"my-env" @
        s" eval" @  
        call_in

        "Reading Second Environment!"
        out
        #\newline out        

        100
loop:   
        proc test-env-read
        s"my-env2" @
        s" eval" @  
        call_in

        1 -
        dup

        0 =
        jnf done

        jmp loop

done:

        proc test-env-read
        s"my-env" @
        s" eval" @  
        call_in
        
        jmp exit


        ;; Simple block of code to execute in the given environment
test-env-bind:
        "In Env" s"B" bind
        0 s"count" bind


        call test-env-read
        
        ret

        ;; Second simple block of code to execute in the given environment
test-env-bind2:
        "In Env2" s"B" bind
        0 s"count" bind

        call test-env-read
        
        ret

        ;; Simple block of code to retrieve value bound in environment
test-env-read:

        "Read in Env: "
        out
        s"B" @
        out
        #\newline
        out

        "Count in Env: " out
        s"count" @ dup out
        #\newline out
        
        ;; increment count
        1 + s"count" !

        ret
        
        

exit:
        "Done."
        out
        #\newline
        out
