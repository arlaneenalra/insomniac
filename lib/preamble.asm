;;; Insomniac Preable code

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

        ;; stack should be ( scheme runtime alist -- )
        rot ;; ( alist scheme runtime -- )
        rot ;; ( runtime alist scheme -- )
        
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

        ;; force a child env for scheme to protect 
        ;; top level bindings
        ;; ( ret scheme -- )
        proc push-env
        swap call_in
        s"scheme-env" bind ;; bind the scheme env

        ;; setup special bindings for certain scheme functions
        ()
        proc eval s"eval" cons cons
        proc define s"define" cons cons
        proc scheme-lambda s"lambda" cons cons

        ;; ( ret alist -- )
        
        swap
        ret

        ;; Bind scheme primitives
        ;; expects ( alist ret -- )
bind-scheme-primitives:

        proc scheme-begin s"begin" bind
        proc scheme-cons s"cons" bind
        proc scheme-quote s"quote" bind
        proc scheme-dump-env s"dump-env" bind
        ;; proc scheme-lambda s"lambda" bind
        
        ;; should have:
        ;; ( alist ret -- )
        proc bind-symbols
        jin  ;; we let bind-symbols return for us

        ;; Bootstrap evaluator
        ;; ( value ret -- )
eval:
        swap ;; save return

        ;; check for things that self evaluate
        dup self?
        jnf eval-self-eval

        dup pair? ;; check to see if the first element is a list
        jnf eval-scheme-call

        dup symbol?
        jnf eval-lookup-symbol-in-env

        dup proc?
        jnf eval-call

        ;; what ever we have is not something that should be 
        ;; eval'd panic!
        jmp panic

        ;; lookup a symbol in an environment
eval-lookup-symbol-in-env:
        proc eval-lookup-symbol

        s"scheme-env" @
        call call-in-env
        
        swap
        ret

        ;; look up a symbol and leave its value on the stack
eval-lookup-symbol:
        swap @ swap
        ret

eval-scheme-call:
        dup cdr ;; pull out any arguments
        
        swap car ;; pull out what's being called

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

        ;; define - the most basic form of define
define:
        swap

        dup cdr car ;; ectract value
        call eval ;; evaluate it

        swap car  ;; get symbol to bind it to

        proc define-in-env
        s"scheme-env" @
        call call-in-env
       
        () swap
        ret
        
        ;; define a value in a particular env
        ;; expects ( value symbol ret -- )
define-in-env:
        rot bind ret

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
        drop ;; drop the empty list
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
        swap

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
        call eval ;; evaluate the value
        
        swap rot ;; (arg-names argumets arg value -- )

        swap ;; ( arg-names arguments value arg -- )

        cons s"alist" @ swap cons ;; add pair to alist

        s"alist" ! ;; update alist

        ;; ( arg-names arguments -- )

        cdr swap cdr ;; get the next argument
        jmp slbc-alist-loop

slbc-alist-done:
        drop drop ;; get rid of the empty lists
       
        ;; bind a new child scheme-env
        proc push-env
        s"scheme-env" @ call_in ;; push env needs a call_in


        ;; s"scheme-env" bind 
        dup ;; ( ret child-env child-env -- )

        s"alist" @ swap ;; ( ret child-env alist child-env -- )
        proc bind-symbols
        swap
        call call-in-env
        
        s"scheme-env" bind ;; bind a new scheme-env
        proc eval s"eval" bind
        proc scheme-begin s"begin" bind
        proc scheme-lambda s"lambda" bind
        proc scheme-dump-env s"dump-env" bind

        ;; Something is not righ here
        ;; ( ret child-env -- )
        s"lambda-body" @ s"begin" cons
        call eval

        swap
        ret

scheme-dump-env:
        swap drop
        proc scheme-dump-env

        swap 
        ret

        ;; User code entry point
        ;; This should leave a single list on the stack to 
        ;; evaluate.
start: 


