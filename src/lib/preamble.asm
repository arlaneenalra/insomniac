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
        car
        cdr
        swap ret

scheme-set!:
        swap
        dup car car ;; symbol
        swap cdr car ;; value
        !
        ()
        swap ret

scheme-call-cc-return:

;; Empty everything on the stack
scheme-call-cc-empty:
        depth 0 =
        jnf scheme-call-cc-empty-done

        drop
        jmp scheme-call-cc-empty

        scheme-call-cc-empty-done:

        s"stack-save" @
scheme-call-cc-restore:
        dup null?
        jnf scheme-call-cc-restore-done

        dup car ;; push the next stack value back onto the stack
        swap ;; push the next value below the list
        cdr ;; move to the next saved stack entry

        jmp scheme-call-cc-restore
scheme-call-cc-restore-done:
        drop

        s"ret-val" @
        s"return" @ ;; return to the called parent
        ret

scheme-call-cc-exit:
        drop ;; get rid of the old return address
        car s"ret-val" bind ;; get the return value

        jmp scheme-call-cc-return

scheme-call-cc:
        swap
        car s"proc" bind ;; setup the proc to call
        s"return" bind ;; bind the return value

        ;; Store the stack so we can restore it after call/cc
        () s"stack-save" bind
scheme-call-cc-save:
        depth
        0 =
        jnf scheme-call-cc-stack-save-exit

        s"stack-save" @             ; read the save list
        swap                        ; swap the top of the stack and the save list
        cons                        ; add the top of the stack to the list
        s"stack-save" !             ; save to stack-save

        jmp scheme-call-cc-save

scheme-call-cc-stack-save-exit:

        ;; Setup the exit routine
        ()
        proc scheme-call-cc-exit
        cons

        ;; Call the
        s"proc" @
        call_in
        s"ret-val" bind

        jmp scheme-call-cc-return

scheme-emergency-exit:
        drop ;; drop return
        car set-exit ;; set the exit status

        jmp panic ;; panic

scheme-command-line:
        swap drop

        s"command-line" @

        swap ret

make-command-line-proc:
        swap

        s"command-line" bind 

        proc scheme-command-line

        swap ret

user-entry:
        drop ;; drop return address, we won't need it

        s"null-environment" bind ;; bind the initial environment

        ;; The command line should be on the stack after the null-environment
        call make-command-line-proc s"command-line" bind

        proc env s"bootstrap-environment" bind ;; the current env

        proc scheme-depth s"depth" bind
        proc scheme-gc-stats s"gc-stats" bind
        proc scheme-emergency-exit s"emergency-exit" bind

        proc scheme-car s"car" bind
        proc scheme-cdr s"cdr" bind
        proc scheme-set! s"set!" bind
        proc scheme-call-cc s"prim-call/cc" bind
_main:

