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


user-entry:
        drop ;; drop return address, we won't need it

        s"initial-environment" bind ;; bind the initial environment
        proc env s"bootstrap-environment" bind ;; the current env

        proc scheme-depth s"depth" bind
        proc scheme-gc-stats s"gc-stats" bind
_main:

