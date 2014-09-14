;;; Insomniac Preable code
;;;        ;; setup scheme primitives
;;;        call push-env
;;;        dup ;; save this so we can bind it in the runtime env
;;;
;;;        ;; bind scheme primitives in the scheme env
;;;        proc bind-scheme-primitives
;;;        swap
;;;        call call-in-env 
;;;      
;;;        ;; stack should be ( scheme -- )
;;;        call push-env ;; this will be the runtime environment
;;;        dup
;;;
;;;        ;; stack should be ( scheme runtime runtime -- )
;;;        proc bind-runtime-env
;;;        swap ;; stack should be ( scheme runtime bind-runtime runtime -- )
;;;        call call-in-env 


        call push-env ;; scheme
        dup
        call push-env ;; runtime
        dup 
        rot
        
        ;; setup runtime env
        ;; stack should be ( scheme runtime scheme runtime -- )
        dup ;; ( scheme runtime scheme runtime runtime -- )
        proc bind-runtime-env
        swap
        call call-in-env

        ;; stack should be ( scheme runtime eval -- )
        rot ;; ( eval scheme runtime -- )
        rot ;; ( runtime eval scheme -- )
        
        proc bind-scheme-primitives
        swap
        call call-in-env

        ;; Stack should be ( runtime -- )
         

        ;; jump to entry point
        jmp start

env:
        swap jin

push-env:
        proc env

call-in-env:
        swap
        ret

        ;; setup any global bindings needed by the runtime code
        ;; should have the scheme env as an argument
        ;; expects ( scheme runtime ret -- eval )
bind-runtime-env:
        rot ;; ( ret scheme runtime -- )
       

        s"runtime-env" bind ;; bind the runtime env
        s"scheme-env" bind ;; bind the scheme env

        proc eval dup s"eval" bind                
        
        ;; ( ret eval -- )
        
        swap
        ret

        ;; Bind scheme primitives
        ;; expects ( eval ret -- )
bind-scheme-primitives:
        swap
        
        s"eval" bind

        proc scheme-begin s"begin" bind
        proc scheme-define s"define" bind
        proc scheme-cons s"cons" bind
        proc scheme-quote s"quote" bind
        proc scheme-lambda s"lamdba" bind
        
        ;; no return, no swap
        ret

        ;; Bootstrap evaluator 
eval:
        swap ;; save return

        ;; check for things that self evaluate
        dup self?
        jnf eval-self-eval

        dup pair? ;; check to see if the first element is a list
        jnf eval-scheme-call

        dup symbol?
        jnf eval-lookup-symbol-in-env

        ;; what ever we have is not something that should be 
        ;; eval'd panic!
        jmp panic

        ;; lookup a symbol in an environment
eval-lookup-symbol-in-env:
        proc eval-lookup-symbol
        dup out #\newline out

        s"scheme-env" @
        call call-in-env
        
        swap
        ret

        ;; look up a symbol and leave its value on the stack
eval-lookup-symbol:
        swap @ swap
        ret

eval-scheme-call:
        "Scheme call" out #\newline out

        dup cdr ;; pull out any arguments
        
        swap car ;; pull out what's being called

        dup out #\newline out

        call eval ;; it wasn't a symbol, evaluate it

eval-call: ;; Do an indirect call for the retrieved value
        
        ;; s"scheme-env" @
        ;; call call-in-env
        
        call_in ;; call the closure

        swap
        ret

eval-self-eval: ;; this object is self evaluatable

        swap
        ret

;;; Scheme runtime functions

        ;; begin - execute a list of s-expressions
scheme-begin:
        swap

scheme-begin-loop:
        dup car ;; pull first item out of list
        ;; call eval ;; evaluate the current expression
        s"eval" @ call_in

        ;; is this the last entry in the begin?
        swap cdr dup null?
        jnf scheme-begin-done
        
        swap drop ;; throw away the intermediate returns
        
        jmp scheme-begin-loop

scheme-begin-done:
        
        drop ;; drop empty list

        swap
        ret

        ;; define - the most basic form of define
scheme-define:
        ;;dup rot  ;; this leaves us with ( ret args ret )
        swap

        dup cdr car ;; ectract value

        ;;call eval ;; evaluate it
        s"eval" @ call_in

        swap car  ;; get symbol to bind it to
        bind      ;; bind symbol
         
        () swap

        ret

        ;; quote - return passed in arguments without processing
scheme-quote:
        swap car swap
        ret

        ;; cons - TODO: revisit this
scheme-cons:
        swap

        dup cdr car swap car cons

        swap 
        ret

        ;; Runtime lambda generator
scheme-lambda:
        swap

        dup cdr car ;; procedure body
        car ;; argument names



        swap
        ret

        ;; User code entry point
        ;; This should leave a single list on the stack to 
        ;; evaluate.
start: 


