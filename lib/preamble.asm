;;; Insomniac Preable code

        ;; Setup bare environment
        call push-env ;; bare
        
        call bind-runtime-env

        ;; if we return here, something went very wrong
        "User code returned instead of calling exit!" out
        #\newline out
        jmp panic

env:
        swap jin

push-env:
        proc env ;; I'm not sure this needs to be anything particular

call-in-env:
        swap
        ret

        ;; Setup any global bindings needed by the runtime code
        ;; should have the scheme env as an argument
        ;; expects ( bare ret -- runtime )
bind-runtime-env:
        swap 

        s"bare-env" bind ;; bind the runtime env

        proc eval s"eval" bind 
        proc define s"define" bind

        proc scheme-begin s"begin" bind
        proc scheme-cons s"cons" bind
        proc scheme-quote s"quote" bind
        proc scheme-dump-env s"dump-env" bind
        proc scheme-lambda s"lambda" bind

        ;; Special Symobls
        proc push-env s"push-env" bind
        proc bind-symbols s"bind-symbols" bind
       
        jmp start

        ;; Bootstrap evaluator
        ;; ( value ret -- )
eval:
        swap ;; save return

        ;; check for things that self evaluate
        dup self?
        jnf eval-done

        dup pair? ;; check to see if the first element is a list
        jnf eval-scheme-call

        dup symbol?
        jnf eval-lookup-symbol

        dup proc? ;; for now, treat procedures as self-eval
        jnf eval-done

        ;; what ever we have is not something that should be 
        ;; eval'd panic!
        "Unknown object type in eval!" out
        #\newline out

        jmp panic

        ;; look up a symbol and leave its value on the stack
eval-lookup-symbol:
        @
        jmp eval-done

eval-scheme-call:
        dup cdr ;; pull out any arguments
        swap car ;; pull out what's being called
        
        ;; ( ret args proc -- )
        swap rot
        ;; ( args ret proc -- )

        "EVAL:" out dup out #\newline out
        call eval ;; it was a symbol, evaluate it
 
        ;; jin
        ret

eval-done:

        swap
        ret

        ;; define - the most basic form of define
        ;; ( (sym . value) ret -- )
define:
        dup ;; ( (sym . value) ret ret -- )

        proc define-bind ;; ( ( sym . value ) ret ret def-bind -- )
        swap adopt ;; setup the define call reflector
        
       
        ;; ( (sym . value) ret def-bind -- )

        ;; Return dumps us into the newly minted closure 
        ;; with out creating a new environent 

        ret

        ;; Bind a symbol, used by define
        ;; ( (sym . value) ret -- )
define-bind:
        swap 

        dup cdr car ;; ectract value
        call eval ;; evaluate it
        
        ;; ( ret (sym . value) value --)
        swap car  ;; get symbol to bind it to

        bind ;; bind the symbol

        ;;"Defined" out #\newline out
        ;;proc env out #\newline out

        () swap
        ret

        ;; Bind symbols into the current environment
        ;; ( alist ret -- )
bind-symbols:
        swap
        
        ;; do the actual symbol binding
bind-symbols-loop:
        dup null?
        jnf bind-symbols-loop-done

        dup car
        dup cdr swap car ;; (rest value key --)
        bind

        cdr ;; next entry
        jmp bind-symbols-loop

bind-symbols-loop-done:
        drop ;; drop empty list

        ret

;;; Scheme runtime functions

        ;; begin - execute a list of s-expressions
        ;; ( body ret -- )
scheme-begin:
        ;; make sure that eval works in the current env
        ;; dup s"eval" @ swap adopt s"eval" bind

        swap

scheme-begin-loop:
        dup car ;; pull first item out of list
        ;;s"eval" @ call_in
        call eval

        ;; is this the last entry in the begin?
        swap cdr dup null?
        jnf scheme-begin-done
        
        swap drop ;; throw away the intermediate returns
        
        jmp scheme-begin-loop

scheme-begin-done:
        
        drop ;; drop empty list

        swap
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
        call scheme-lambda-push

        swap
        ret


scheme-lambda-push:
        swap

        dup ;; make a second copy of the lambda

        car s"lambda-args" bind ;; bind arguments
        
        cdr s"lambda-body" bind ;; bind the body
        
        dup ;; return in this instance should be an env
        s"lambda-scope" bind

        ;; out put the procedure
        proc scheme-lambda-binding-closure
        
        swap
        ret

        ;; Closure that binds the arguments to their locations
        ;; and dumps the lambda body to begin
        ;; ( arguments ret -- )
scheme-lambda-binding-closure:
        dup s"parent" bind ;; bind our parent so we have it handy
        
        proc eval swap adopt s"p-eval" bind ;; setup an eval

        () s"alist" bind ;; setup the new list
        s"lambda-args" @ ;; retrieve the argument names

        ;; ( arguments arg-names -- )
slbc-alist-loop:
        ;; are we at the end of the list?
        dup null? jnf slbc-alist-done
        
        dup car ;; get the next argument

        ;; ( arguments arg-names arg -- )
        ;;swap rot swap ;; ( arg-names arg arguments  -- )
        rot rot ;; ( arg-names arg arguments  -- )

        dup car ;; get the next argument value

        ;; evaluate the value in our parent context
        s"p-eval" @ call_in
        
        swap rot ;; (arg-names argumets arg value -- )

        swap ;; ( arg-names arguments value arg -- )

        cons s"alist" @ swap cons ;; add pair to alist

        s"alist" ! ;; update alist

        ;; ( arg-names arguments -- )

        cdr swap cdr ;; get the next argument
        jmp slbc-alist-loop

slbc-alist-done:
        drop drop ;; get rid of the empty lists

        ;; bind a new child env
        s"push-env" @ s"parent" @ adopt
        call_in

        ;; bind symbols in the new env
        dup s"bind-symbols" @ swap adopt
        s"bind-in-env" bind

        ;;s"p-eval" @
        proc slbc-alist-debug swap adopt ;; setup eval call for child
        
        ;; Something is not righ here
        ;; ( eval lambda-body -- )
        s"lambda-body" @ s"begin" cons
       
        s"parent" @ ;; ( eval lambda-body ret -- )
        swap  ;; ( eval ret lambda-body -- )
        rot   ;; ( lambda-body eval ret -- )
        swap ;; ( lambda-body ret eval -- )
        
        s"alist" @ ;; ( lambda-body ret eval alist -- ) 
        swap s"bind-in-env" @ 
        
        ;; ( lambda-body ret alist eval bind-symbols -- )
        call stack_dump
        ret ;; return to bind-symbols

slbc-alist-debug:
        "BIND" out #\newline out
        call stack_dump
        #\newline out
        jmp eval

scheme-dump-env:
        swap drop
        proc scheme-dump-env

        swap 
        ret

        ;; User code entry point
        ;; This should leave a single list on the stack to 
        ;; evaluate.
start: 


