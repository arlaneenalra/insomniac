;;; Insomniac Preable code
 
        ;; Setup Environment functions
        proc env s" root-env" bind
        proc push-env s" make-child" bind
        proc call-in-env s" call-in-env" bind

        ;; Bind scheme primitives
        proc scheme-begin s"begin" bind
        proc scheme-define s"define" bind
        proc scheme-cons s"cons" bind
        
        ;; jump to entry point
        jmp start

env:
        swap jin

push-env:
        proc env
call-in-env:
        swap
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
        jnf eval-lookup-symbol

        ;; what ever we have is not something that should be 
        ;; eval'd panic!
        jmp panic

eval-lookup-symbol:
        @

        swap
        ret

eval-scheme-call:
        dup cdr ;; pull out any arguments
        
        swap car ;; pull out what's being called

        call eval ;; it wasn't a symbol, evaluate it

eval-call: ;; Do an indirect call for the retrieved value

        s" root-env" @
        s" call-in-env" @
        call_in

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
        call eval ;; evaluate the current expression

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

        call eval ;; evaluate it

        swap car  ;; get symbol to bind it to
        bind      ;; bind symbol
         
        () swap

        ret

        ;; cons - TODO: revisit this
scheme-cons:
        swap

        dup cdr car swap car cons

        swap 
        ret

        ;; User code entry point
        ;; This should leave a single list on the stack to 
        ;; evaluate.
start: 


