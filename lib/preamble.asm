;;; Insomniac Preamble/Base Library Code

        proc env
        call user-entry

;; Setup an environment
env:
        swap jin

;; Put the stack depth on the stack
scheme-depth:
        swap
        drop depth
        swap ret

;; Output staticstics about the garbage collector
scheme-gc-stats:
        swap drop
        gc-stats
        () swap
        ret

;; CAR, CDR and friends
scheme-car:
        swap
        car car
        swap ret

scheme-cdr:
        swap
        car cdr
        swap ret

scheme-set!:
        swap
        dup car car ;; symbol
        swap cdr car ;; value
        !
        ()
        swap ret

;; The arguments should already have had cons applied ;)
scheme-cons:
        ret

scheme-emergency-exit:
        drop ;; drop return
        car set-exit ;; set the exit status

        jmp panic ;; panic

user-entry:
        drop ;; drop return address, we won't need it

        s"null-environment" bind ;; bind the initial environment
        proc env s"bootstrap-environment" bind ;; the current env

        proc scheme-depth s"depth" bind
        proc scheme-gc-stats s"gc-stats" bind
        proc scheme-emergency-exit s"emergency-exit" bind

        proc scheme-car s"car" bind
        proc scheme-cdr s"cdr" bind
        proc scheme-cons s"cons" bind
        proc scheme-set! s"set!" bind
_main:

