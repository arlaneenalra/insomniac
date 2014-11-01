;;; Creating an evnironment object that can be passed around

        ;; Setup the empty environment
        proc env
        s" root_env" bind

        ;; Funciton to make child environments
        proc push-env
        s" push_env" bind

        ;; call entry point to protect top level
        ;; bindings at run time
        call start

        ;; ( proc ret -- ) 
env:
        ;;" - In Root - " out
        swap
        jin

        ;; execute in env to create a child of that environment
        ;; and return it
push-env:

        proc env

        swap
        ret

        ;; actually run code in an environment
eval:
        swap
        ret
        
start:
        1 s"B" bind

        ;; create our own child environment
        ;; proc push-env ;; s" push_env" @
        ;; s" root_env" @
        ;; call_in
        call push-env

        s"my-env" bind

        ;; create our own child environment
        ;; proc push-env ;; s" push_env" @
        ;; s" root_env" @
        ;; call_in

        ;; call push-env
        proc push-env
        s"my-env" @ call_in
        ;; call eval


        s"my-env2" bind
        
        
        " - Created child environments - "
        out
        #\newline
        out

        ;; bind a value in the new environment
        proc test-env-bind
        s"my-env" @
        call eval

        
        ;; bind a value in the new environment
        proc test-env-bind2
        s"my-env2" @
        call eval

        #\newline out

        "Reading Environment!"
        out
        #\newline out

        proc test-env-read
        s"my-env" @
        call eval

        "Reading Second Environment!"
        out
        #\newline out        

        10
loop:   
        proc test-env-read
        s"my-env2" @
        call eval

        1 -
        dup

        0 =
        jnf done

        jmp loop

done:

        proc test-env-read
        s"my-env" @
        call eval
        
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
