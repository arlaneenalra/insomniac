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

        ;;proc scheme-begin s"begin" bind
        proc scheme-cons s"cons" bind
        proc scheme-quote s"quote" bind
        proc scheme-dump-env s"dump-env" bind
        proc scheme-lambda s"lambda" bind
        proc scheme-display s"display" bind
        proc scheme-depth s"depth" bind

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

eval-scheme-call: ;; ( ret call-list --)
        
        dup car ;; ( ret call-list proc-sym -- )

        dup s"quote" eq
        jnf eval-no-eval-args

        dup s"begin" eq
        jnf eval-no-eval-args
        
        dup s"define" eq
        jnf eval-no-eval-args

        dup s"lambda" eq
        jnf eval-no-eval-args

        ;; setup for arguments eval
        swap cdr ;; ( ret proc-sym args -- )
        jmp eval-args-loop-setup

        ;; do not evaluate the arguments
eval-no-eval-args:
        ;; ( ret call-list proc-sym -- )
        swap cdr ;; ( ret proc-sym args -- )
        swap ;; ( ret args proc-sym -- )

        jmp eval-args-done
        
        ;; evaluate arguments
eval-args-loop-setup: ;; ( ret proc-sym args -- )
        () swap ;; ( ret proc-sym evaled-args args -- )

eval-args-loop: ;; ( ret proc-sym evaled-args args -- )
        dup null?
        jnf eval-args-loop-reverse-setup

        dup car ;; (ret proc-sym evaled-args args arg -- )
        
        call eval
        
        swap rot ;; (ret proc-sym args evaled-args arg -- )
        cons ;; (ret proc-sym args evaled-args -- )
        swap cdr   ;; move to next element
        
        jmp eval-args-loop

eval-args-loop-reverse-setup:
        swap
      
eval-args-loop-reverse: ;; (ret proc-sym args evaled-ags -- )
        dup null?
        jnf eval-args-loop-reverse-done

        dup car ;; (ret proc-sym args evaled-args arg -- )

        swap rot  ;; (ret proc-sym evaled-args args arg -- )
        cons
        swap cdr ;; move to next element
        
        jmp eval-args-loop-reverse

        ;; drop the now empty evaled-args list
eval-args-loop-reverse-done: ;; (ret proc-sym args evaled-args -- )

        drop swap
        
eval-args-done:

        ;; ( ret args proc -- )
        swap rot
        ;; ( args ret proc -- )

        ;; is the Symbol a special form?
        dup s"begin" eq
        jnf eval-begin

        dup s"dump-env" eq
        jnf eval-special

        dup s"lambda" eq
        jnf eval-lambda


        call eval ;; it was a symbol, evaluate it
        ret

        ;; for certain forms, save environment
eval-special:
        call eval
       
        jin

eval-lambda:
        drop
        jmp scheme-lambda

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
        ;; ( body symbol -- )
eval-begin:
        drop ;; drop the symbol
        swap

        ;; if we have an empty body do nothing
        dup null?
        jnf eval-done

eval-begin-loop: ;; ( ret body -- )

        dup cdr null? ;; are we on the next to last element?
        jnf eval-begin-tail

        dup car 
        call eval

scb-next:
        drop ;; throw away the intermediate returns
        cdr ;; get the next entry 
        jmp eval-begin-loop

eval-begin-tail:

        car
        swap
        jmp eval
        
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
;;        swap
        call scheme-lambda-push



scheme-lambda-push:
        drop
        swap


        dup ;; make a second copy of the lambda

        car s"lambda-args" bind ;; bind arguments
        
        cdr s"begin" cons s"lambda-body" bind ;; bind the body

        ;; output the procedure
        proc scheme-lambda-binding-closure
        
        swap
        ret

        ;; Closure that binds the arguments to their locations
        ;; and dumps the lambda body to begin
        ;; ( arguments ret -- )
scheme-lambda-binding-closure:

        ;; make sure we're in a child of the base closure proc
        ;; This is needed because eval doesn't call it does a ret
        ;; or jin
        call slbc-push-next
slbc-push-next:
        drop

        ;;dup
        s"parent" bind ;; bind our parent so we have it handy       
        

        ;; TODO - This pattern breaks tail calls!

        ;; setup eval call trampoline
        ;; proc slbc-eval-trampoline swap adopt s"eval-trampoline" bind

        () s"alist" bind ;; setup the new list
        s"lambda-args" @ ;; retrieve the argument names

slbc-alist-loop:
        ;; are we at the end of the list?
        dup null? jnf slbc-alist-done
        
        dup car ;; get the next argument

        ;; ( arguments arg-names arg -- )
        ;;swap rot swap ;; ( arg-names arg arguments  -- )
        rot rot ;; ( arg-names arg arguments  -- )

        dup car ;; get the next argument value

        ;; evaluate the value in our parent context
        ;; s"eval-trampoline" @ call_in
        
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

        s"eval" @ swap adopt ;; setup eval call for child
        
        ;; Something is not right here
        ;; ( eval lambda-body -- )
        s"lambda-body"  @ 
       
        s"parent" @ ;; ( eval lambda-body ret -- )
        swap  ;; ( eval ret lambda-body -- )
        rot   ;; ( lambda-body eval ret -- )
        swap ;; ( lambda-body ret eval -- )
        
        s"alist" @ ;; ( lambda-body ret eval alist -- ) 
        swap s"bind-in-env" @ 
       
        ;; ( lambda-body ret alist eval bind-symbols -- )
        ret ;; return to bind-symbols

scheme-dump-env:
        swap drop
        "ENV:" out #\newline out
        proc scheme-dump-env
        out
        ()
        swap 
        ret

scheme-display:
        swap
        car
        out
        () swap
        ret

scheme-depth:
        swap
        drop depth
        swap ret

        ;; User code entry point
        ;; This should leave a single list on the stack to 
        ;; evaluate.
start: 


