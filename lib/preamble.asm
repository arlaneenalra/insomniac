;;; Insomniac Preable code
 
        ;; Setup Environment functions
        proc env s" root-env" bind
        proc push-env s" make-child" bind
        proc call-in-env s" call-in-env" bind

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
        car dup pair? ;; check to see if the first element is a list
        jnf eval-lambda

        dup symbol? ;; if we have a symbol, look it up
        jnf eval-symbol

eval-symbol:
        @
        jmp eval-call

eval-lambda:
        call eval ;; if it is, evaluate it again

eval-call:
        call_in
        ret

        ;; User code entry point
start: 


