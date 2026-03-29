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

.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 19 39
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 19 39
        jmp _label_1
_label_0:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 19 38
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 19 29
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 19 29
        s"x"
        @
;; ----Escape ASM End----
        out
        ()
;; --Raw ASM End--
        swap ret
_label_1:
        proc _label_0
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 19 18
        s"display"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 20 42
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 20 42
        jmp _label_3
_label_2:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 20 41
;; --Raw ASM Start--
        #\newline
        out
        ()
;; --Raw ASM End--
        swap ret
_label_3:
        proc _label_2
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 20 17
        s"newline"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 36
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 36
        jmp _label_5
_label_4:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
        cdr
;; ----
        dup
        car
        s"b"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 35
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 26
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 26
        s"a"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 30
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 30
        s"b"
        @
;; ----Escape ASM End----
        eq
;; --Raw ASM End--
        swap ret
_label_5:
        proc _label_4
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 23 13
        s"eq?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 24 18
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 24 17
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 24 17
        s"eq?"
        @
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 24 13
        s"eqv?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 27 17
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 27 16
        #t
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 27 13
        s"else"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 43
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 43
        jmp _label_7
_label_6:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"proc"
        bind
        cdr
;; ----
        dup
        car
        s"l"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 53
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 52
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 31 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 31 24
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 31 24
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 31 19
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 31 19
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_8
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 51
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 23
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 23
        s"args"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 27
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 27
        s"l"
        @
;; ----Escape ASM End----
        cons
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 41
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 33 41
        s"append"
        @
;; ----Escape ASM End----
        call_in
;; --Raw ASM End--
        jmp _label_9
;; --If true--
_label_8:
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 32 14
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 32 14
        s"l"
        @
;; --If Done--
_label_9:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 30 21
        s"new-args"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 42
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 20
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 20
        s"new-args"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 27
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 34 27
        s"proc"
        @
;; ----Escape ASM End----
        tail_call_in
;; --Raw ASM End--
        swap ret
_label_7:
        proc _label_6
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 29 16
        s"apply"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 36 30
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 36 29
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 36 29
        s"emergency-exit"
        @
.file "/Users/jules/code/scheme_projects/insomniac/build/src/lib/baselib.scm" 36 14
        s"exit"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 49
        jmp _label_11
_label_10:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"library"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 48
        jmp _label_13
_label_12:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"func"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 47
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 17
        s"args"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 27
        s"library"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 8 34
        s"func"
        @
;; ----Escape ASM End----
        @
        call_ext
;; --Raw ASM End--
        swap ret
_label_13:
        proc _label_12
        swap ret
_label_11:
        proc _label_10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 6 24
        s"import-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 41
        jmp _label_15
_label_14:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"alist"
        bind
        cdr
;; ----
        dup
        car
        s"closure"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 40
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 13 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 13 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 13 21
        s"alist"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 13 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 13 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 31 29
;; --Raw ASM Start--
        proc
        bind-in-done
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 21 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 21 17
        s"alist"
        @
;; ----Escape ASM End----
        car
        proc
        do-bind
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 23 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 23 33
        s"closure"
        @
;; ----Escape ASM End----
        adopt
        ret
        do-bind:
        dup
        cdr
        swap
        car
        bind
        ret
        bind-in-done:
        ()
;; --Raw ASM End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 37
        s"closure"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 28
        s"alist"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 22
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 32 17
        s"bind-in"
        @
        tail_call_in
;; --Call End--
        jmp _label_17
;; --If true--
_label_16:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 14 10
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
;; --If Done--
_label_17:
;; --If End--
        swap ret
_label_15:
        proc _label_14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 12 17
        s"bind-in"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 45 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 45 12
        jmp _label_19
_label_18:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"path"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 39 22
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 37 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 37 12
        s"path"
        @
;; ----Escape ASM End----
        import
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 38 17
;; --Quoted Start--
        s"bindings"
;; --Quoted End--
;; ----Escape ASM End----
        bind
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 39 12
;; --Quoted Start--
        s"lib"
;; --Quoted End--
;; ----Escape ASM End----
        bind
        ()
;; --Raw ASM End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 40
        s"lib"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 36
        s"import-factory"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 41 20
        s"caller"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 29
        s"caller"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 22
        s"bindings"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 44 13
        s"bind-in"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 45 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 45 11
        s"caller"
        @
        swap ret
_label_19:
        proc _label_18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/dynamic.scm" 35 23
        s"import-bind"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 14
        jmp _label_21
_label_20:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 13
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 14 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 14 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 14 9
        s"x"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 14 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 14 11
        s"y"
        @
        > 
        dup
        jnf _label_22
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 9
        s"x"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 15 11
        s"y"
        @
        = 
_label_22:
;; --Bool Operator End--
        swap ret
_label_21:
        proc _label_20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 12 14
        s">="
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 14
        jmp _label_24
_label_23:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 13
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 19 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 19 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 19 9
        s"x"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 19 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 19 11
        s"y"
        @
        < 
        dup
        jnf _label_25
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 9
        s"x"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 20 11
        s"y"
        @
        = 
_label_25:
;; --Bool Operator End--
        swap ret
_label_24:
        proc _label_23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/math.scm" 17 13
        s"<="
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 5 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 5 40
        jmp _label_27
_label_26:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 5 39
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 5 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 5 29
        s"x"
        @
;; ----Escape ASM End----
        fixnum?
;; --Raw ASM End--
        swap ret
_label_27:
        proc _label_26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 5 18
        s"fixnum?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 8 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 8 37
        jmp _label_29
_label_28:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 8 36
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 8 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 8 28
        s"x"
        @
;; ----Escape ASM End----
        char?
;; --Raw ASM End--
        swap ret
_label_29:
        proc _label_28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 8 17
        s"char?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 10 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 10 40
        jmp _label_31
_label_30:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 10 39
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 10 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 10 29
        s"x"
        @
;; ----Escape ASM End----
        string?
;; --Raw ASM End--
        swap ret
_label_31:
        proc _label_30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 10 18
        s"string?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 12 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 12 36
        jmp _label_33
_label_32:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 12 35
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 12 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 12 27
        s"x"
        @
;; ----Escape ASM End----
        pair?
;; --Raw ASM End--
        swap ret
_label_33:
        proc _label_32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 12 16
        s"pair?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 14 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 14 36
        jmp _label_35
_label_34:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 14 35
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 14 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 14 27
        s"x"
        @
;; ----Escape ASM End----
        null?
;; --Raw ASM End--
        swap ret
_label_35:
        proc _label_34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 14 16
        s"null?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 16 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 16 36
        jmp _label_37
_label_36:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 16 35
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 16 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 16 27
        s"x"
        @
;; ----Escape ASM End----
        proc?
;; --Raw ASM End--
        swap ret
_label_37:
        proc _label_36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 16 16
        s"proc?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 18 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 18 40
        jmp _label_39
_label_38:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 18 39
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 18 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 18 29
        s"x"
        @
;; ----Escape ASM End----
        symbol?
;; --Raw ASM End--
        swap ret
_label_39:
        proc _label_38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/predicates.scm" 18 18
        s"symbol?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 31
        jmp _label_41
_label_40:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 30
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 23
        s"a"
        @
        jnf _label_42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 29
        #t
        jmp _label_43
;; --If true--
_label_42:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 26
        #f
;; --If Done--
_label_43:
;; --If End--
        swap ret
_label_41:
        proc _label_40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 5 14
        s"not"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 7 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 7 39
        jmp _label_45
_label_44:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 7 38
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 7 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 7 30
        s"x"
        @
;; ----Escape ASM End----
        bool?
;; --Raw ASM End--
        swap ret
_label_45:
        proc _label_44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 7 19
        s"boolean?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 45
        jmp _label_47
_label_46:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 44
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 19
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 17
        s"boolean?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_49
        jmp _label_48
_label_49:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 32
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 30
        s"boolean?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_50
        jmp _label_48
_label_50:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 42
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 40
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 12 38
        s"eq?"
        @
        call_in
;; --Call End--
_label_48:
;; --Bool Operator End--
        swap ret
_label_47:
        proc _label_46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 11 19
        s"boolean=?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 43
        jmp _label_52
_label_51:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 42
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 19
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 18
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 16
        s"string?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_54
        jmp _label_53
_label_54:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 30
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 28
        s"string?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_55
        jmp _label_53
_label_55:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 40
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 38
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 17 36
        s"eq?"
        @
        call_in
;; --Call End--
_label_53:
;; --Bool Operator End--
        swap ret
_label_52:
        proc _label_51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 16 18
        s"string=?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 40
        jmp _label_57
_label_56:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"seen-x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 39
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 23 19
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 23 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 23 18
        s"seen-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 23 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 23 11
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 23 22
        #f
        jmp _label_58
_label_59:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 23
        s"seen-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 16
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 11
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 9
        s"eq?"
        @
        call_in
;; --Call End--
        not
        jnf _label_60
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 24 28
        #t
        jmp _label_58
_label_60:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 9
        s"else"
        @
        not
        jnf _label_61
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 35
        s"seen-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 28
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 23
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 25 21
        s"equal-seen"
        @
        tail_call_in
;; --Call End--
        jmp _label_58
_label_61:
;; --Cond Fall-Through--
        ()
_label_58:
;; --Cond End--
        swap ret
_label_57:
        proc _label_56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 21 20
        s"equal-seen"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 30
        jmp _label_63
_label_62:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 38
        jmp _label_65
_label_64:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
        cdr
;; ----
        dup
        car
        s"seen-x"
        bind
        cdr
;; ----
        dup
        car
        s"seen-y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 37
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 30
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 32
        s"seen-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 25
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 35 23
        s"equal-seen"
        @
        call_in
;; --Call End--
        dup
        jnf _label_68
        jmp _label_67
_label_68:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 28
        s"seen-y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 21
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 19
        s"equal-seen"
        @
        call_in
;; --Call End--
_label_67:
;; --Bool Operator End--
        not
        jnf _label_69
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 36 33
        #t
        jmp _label_66
_label_69:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 33
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 21
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 19
        s"null?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_71
        jmp _label_70
_label_71:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 31
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 29
        s"null?"
        @
        call_in
;; --Call End--
_label_70:
;; --Bool Operator End--
        not
        jnf _label_72
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 38 36
        #t
        jmp _label_66
_label_72:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 40 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 40 12
        s"else"
        @
        not
        jnf _label_73
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 35
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 34
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 50
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 31
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 29
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 24
        s"pair?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_78
        jmp _label_77
_label_78:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 47
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 45
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 41 40
        s"pair?"
        @
        call_in
;; --Call End--
_label_77:
;; --Bool Operator End--
        jnf _label_75
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 31
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 29
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 23
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 21
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 46 16
        s"equal?"
        @
        call_in
;; --Call End--
        jmp _label_76
;; --If true--
_label_75:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 32
        s"seen-y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 25
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 45 23
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 32
        s"seen-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 25
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 44 23
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 43 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 43 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 43 24
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 43 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 43 22
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 28
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 26
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 42 21
        s"equal-inner"
        @
        call_in
;; --Call End--
;; --If Done--
_label_76:
;; --If End--
        dup
        jnf _label_79
        jmp _label_74
_label_79:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 34
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 51
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 32
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 30
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 25
        s"pair?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_83
        jmp _label_82
_label_83:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 48
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 46
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 48 41
        s"pair?"
        @
        call_in
;; --Call End--
_label_82:
;; --Bool Operator End--
        jnf _label_80
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 31
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 29
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 23
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 21
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 53 16
        s"equal?"
        @
        call_in
;; --Call End--
        jmp _label_81
;; --If true--
_label_80:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 32
        s"seen-y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 25
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 52 23
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 32
        s"seen-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 25
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 51 23
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 50 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 50 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 50 24
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 50 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 50 22
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 28
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 26
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 49 21
        s"equal-inner"
        @
        call_in
;; --Call End--
;; --If Done--
_label_81:
;; --If End--
_label_74:
;; --Bool Operator End--
        jmp _label_66
_label_73:
;; --Cond Fall-Through--
        ()
_label_66:
;; --Cond End--
        swap ret
_label_65:
        proc _label_64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 33 24
        s"equal-inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 28
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 24
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 20
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 18
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 55 16
        s"equal-inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_63:
        proc _label_62
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 31 21
        s"equal-pair?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 34
        jmp _label_85
_label_84:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 31
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 61 29
        s"vector->list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 31
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 29
        s"vector->list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 60 15
        s"equal-pair?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_85:
        proc _label_84
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 59 23
        s"equal-vector?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 34
        jmp _label_87
_label_86:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 31
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 66 29
        s"record->list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 31
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 29
        s"record->list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 65 15
        s"equal-pair?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_87:
        proc _label_86
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 64 23
        s"equal-record?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 28
        jmp _label_89
_label_88:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 39
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 37
        s"bytevector-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 70 18
        s"len-x"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 39
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 37
        s"bytevector-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 71 18
        s"len-y"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 78 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 78 24
        jmp _label_91
_label_90:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 78 23
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 29
        s"len-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 23
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 19
        s"eqv?"
        @
        call_in
;; --Call End--
        not
        jnf _label_93
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 75 33
        #t
        jmp _label_92
_label_93:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 72
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 71
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 70
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 70
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 66
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 66
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 64
        s"bytevector-u8-ref"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 44
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 40
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 38
        s"bytevector-u8-ref"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 76 19
        s"eqv?"
        @
        call_in
;; --Call End--
        not
        jnf _label_94
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 36
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 34
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 27
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 31
        s"idx"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 77 22
        s"walk"
        @
        tail_call_in
;; --Call End--
        jmp _label_92
_label_94:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 78 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 78 18
        s"else"
        @
        not
        jnf _label_95
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 78 21
        #f
        jmp _label_92
_label_95:
;; --Cond Fall-Through--
        ()
_label_92:
;; --Cond End--
        swap ret
_label_91:
        proc _label_90
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 73 19
        s"walk"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 27
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 32
        s"len-y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 26
        s"len-x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 20
        s"eqv?"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 14
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_97
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 81 37
        #f
        jmp _label_96
_label_97:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 82 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 82 14
        s"else"
        @
        not
        jnf _label_98
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 24
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 22
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 20
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 83 18
        s"walk"
        @
        tail_call_in
;; --Call End--
        jmp _label_96
_label_98:
;; --Cond Fall-Through--
        ()
_label_96:
;; --Cond End--
        swap ret
_label_89:
        proc _label_88
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 69 27
        s"equal-bytevector?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 22
        jmp _label_100
_label_99:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
        cdr
;; ----
        dup
        car
        s"y"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 21
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 37
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 22
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 20
        s"boolean?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_103
        jmp _label_102
_label_103:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 35
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 33
        s"boolean?"
        @
        call_in
;; --Call End--
_label_102:
;; --Bool Operator End--
        not
        jnf _label_104
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 52
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 50
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 88 48
        s"boolean=?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_104:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 35
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 21
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 19
        s"string?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_106
        jmp _label_105
_label_106:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 33
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 31
        s"string?"
        @
        call_in
;; --Call End--
_label_105:
;; --Bool Operator End--
        not
        jnf _label_107
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 49
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 47
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 89 45
        s"string=?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_107:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 31
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 19
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 17
        s"pair?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_109
        jmp _label_108
_label_109:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 29
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 27
        s"pair?"
        @
        call_in
;; --Call End--
_label_108:
;; --Bool Operator End--
        not
        jnf _label_110
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 48
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 46
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 90 44
        s"equal-pair?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_110:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 35
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 21
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 19
        s"vector?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_112
        jmp _label_111
_label_112:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 33
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 31
        s"vector?"
        @
        call_in
;; --Call End--
_label_111:
;; --Bool Operator End--
        not
        jnf _label_113
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 54
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 52
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 91 50
        s"equal-vector?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_113:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 43
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 25
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 23
        s"bytevector?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_115
        jmp _label_114
_label_115:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 41
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 39
        s"bytevector?"
        @
        call_in
;; --Call End--
_label_114:
;; --Bool Operator End--
        not
        jnf _label_116
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 67
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 66
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 66
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 64
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 62
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 92 62
        s"equal-bytevector?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_116:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 35
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 21
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 19
        s"record?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_118
        jmp _label_117
_label_118:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 33
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 31
        s"record?"
        @
        call_in
;; --Call End--
_label_117:
;; --Bool Operator End--
        not
        jnf _label_119
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 54
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 52
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 93 50
        s"equal-record?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_119:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 96 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 96 10
        s"else"
        @
        not
        jnf _label_120
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 17
        s"y"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 15
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 98 13
        s"eqv?"
        @
        tail_call_in
;; --Call End--
        jmp _label_101
_label_120:
;; --Cond Fall-Through--
        ()
_label_101:
;; --Cond End--
        swap ret
_label_100:
        proc _label_99
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/boolean.scm" 86 16
        s"equal?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 48
        jmp _label_122
_label_121:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"car"
        bind
        cdr
;; ----
        dup
        car
        s"cdr"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 47
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 34
        s"cdr"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 40
        s"car"
        @
;; ----Escape ASM End----
        cons
;; --Raw ASM End--
        swap ret
_label_122:
        proc _label_121
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 5 15
        s"cons"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 57
        jmp _label_124
_label_123:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"pair"
        bind
        cdr
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 56
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 40
        s"pair"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 46
        s"obj"
        @
;; ----Escape ASM End----
        set-car
;; --Raw ASM End--
        swap ret
_label_124:
        proc _label_123
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 7 19
        s"set-car!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 56
        jmp _label_126
_label_125:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"pair"
        bind
        cdr
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 55
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 39
        s"pair"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 45
        s"obj"
        @
;; ----Escape ASM End----
        set-cdr
;; --Raw ASM End--
        swap ret
_label_126:
        proc _label_125
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 8 18
        s"set-cdr!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 10 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 10 27
        jmp _label_128
_label_127:
        swap
;; -- Formals --
;; ----
        s"x"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 10 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 10 26
        s"x"
        @
        swap ret
_label_128:
        proc _label_127
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 10 14
        s"list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 18
        jmp _label_130
_label_129:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 37
        jmp _label_132
_label_131:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        dup
        car
        s"len"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 36
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 15 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 15 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 15 20
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 15 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 15 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_133
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 29
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 33
        s"len"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 23
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 18
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 17 13
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_134
;; --If true--
_label_133:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 16 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 16 10
        s"len"
        @
;; --If Done--
_label_134:
;; --If End--
        swap ret
_label_132:
        proc _label_131
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 14 17
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 17
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 16
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 14
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 18 9
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_130:
        proc _label_129
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 13 16
        s"length"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 20
        jmp _label_136
_label_135:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 43
        jmp _label_138
_label_137:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        dup
        car
        s"rev-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 42
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 23 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 23 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 23 20
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 23 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 23 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_139
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 39
        s"rev-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 29
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 24
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 26 19
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 23
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 18
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 25 13
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_140
;; --If true--
_label_139:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 24 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 24 15
        s"rev-list"
        @
;; --If Done--
_label_140:
;; --If End--
        swap ret
_label_138:
        proc _label_137
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 22 17
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 19
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 18
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 14
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 27 9
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_136:
        proc _label_135
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 21 17
        s"reverse"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 21
        jmp _label_142
_label_141:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 35
        jmp _label_144
_label_143:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        dup
        car
        s"accum"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 34
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 32 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 32 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 32 20
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 32 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 32 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_145
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 33
;; -- Let* --
        ()
        proc _label_147
        tail_call_in
_label_147:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 36
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 31
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 26
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 21
        s"cons"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 35 15
        s"next"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 30
        s"next"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 25
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 37 19
        s"set-cdr!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 31
        s"next"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 25
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 20
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 38 15
        s"inner"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_148:
;; -- Let* End --
        jmp _label_146
;; --If true--
_label_145:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 33 10
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
;; --If Done--
_label_146:
;; --If End--
        swap ret
_label_144:
        proc _label_143
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 31 17
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 20
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 40 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 40 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 40 28
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 40 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 40 23
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_149
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 19
;; -- Let* --
        ()
        proc _label_151
        tail_call_in
_label_151:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 43 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 43 25
;; --Quoted Start--
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted Start--
        ()
;; --Quoted End--
        cons
;; --Quoted End--
;; --Quoted End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 43 14
        s"accum"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 25
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 19
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 45 14
        s"inner"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 17
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 46 11
        s"cdr"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_152:
;; -- Let* End --
        jmp _label_150
;; --If true--
_label_149:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 41 8
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
;; --If Done--
_label_150:
;; --If End--
        swap ret
_label_142:
        proc _label_141
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 30 19
        s"list-copy"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 18
        jmp _label_154
_label_153:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 43
        jmp _label_156
_label_155:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
        cdr
;; ----
        dup
        car
        s"accum"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 42
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 39
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 24
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 19
        s"null?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_159
        jmp _label_158
_label_159:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 37
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 53 32
        s"null?"
        @
        call_in
;; --Call End--
_label_158:
;; --Bool Operator End--
        not
        jnf _label_160
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 54 12
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        jmp _label_157
_label_160:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 55 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 55 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 55 19
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 55 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 55 14
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_161
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 43
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 36
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 31
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 25
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 20
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 56 15
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_157
_label_161:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 57 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 57 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 57 19
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 57 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 57 14
        s"pair?"
        @
        call_in
;; --Call End--
        not
        jnf _label_162
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 47
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 42
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 37
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 32
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 26
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 59 20
        s"set-cdr!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 44
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 38
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 33
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 27
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 22
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 60 17
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_157
_label_162:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 61 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 61 12
        s"else"
        @
        not
        jnf _label_163
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 31
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 26
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 63 20
        s"set-cdr!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 37
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 31
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 26
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 21
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 64 17
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_157
_label_163:
;; --Cond Fall-Through--
        ()
_label_157:
;; --Cond End--
        swap ret
_label_156:
        proc _label_155
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 51 17
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 17
;; -- Let* --
        ()
        proc _label_164
        tail_call_in
_label_164:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 67 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 67 23
;; --Quoted Start--
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted Start--
        ()
;; --Quoted End--
        cons
;; --Quoted End--
;; --Quoted End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 67 12
        s"accum"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 28
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 22
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 17
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 69 12
        s"inner"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 16
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 15
        s"accum"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 70 9
        s"cdr"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_165:
;; -- Let* End --
        swap ret
_label_154:
        proc _label_153
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 50 16
        s"append"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 43
        jmp _label_167
_label_166:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        s"pred"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 40
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 20
        s"pred"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_168
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 38
        s"pred"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 33
        s"car"
        @
        call_in
;; --Call End--
        jmp _label_169
;; --If true--
_label_168:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 76 28
        s"equal?"
        @
;; --If Done--
_label_169:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 75 14
        s"pred"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 42
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 80 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 80 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 80 17
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 80 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 80 12
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_171
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 80 21
        #f
        jmp _label_170
_label_171:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 26
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 21
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 16
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 11
        s"pred"
        @
        call_in
;; --Call End--
        not
        jnf _label_172
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 83 32
        s"list"
        @
        jmp _label_170
_label_172:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 11
        s"else"
        @
        not
        jnf _label_173
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 39
        s"pred"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 33
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 28
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 23
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 85 19
        s"member"
        @
        tail_call_in
;; --Call End--
        jmp _label_170
_label_173:
;; --Cond Fall-Through--
        ()
_label_170:
;; --Cond End--
        swap ret
_label_167:
        proc _label_166
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 73 16
        s"member"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 25
        jmp _label_175
_label_174:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 23
        s"eq?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 19
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 14
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 89 10
        s"member"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_175:
        proc _label_174
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 88 14
        s"memq"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 26
        jmp _label_177
_label_176:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 24
        s"eqv?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 19
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 14
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 92 10
        s"member"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_177:
        proc _label_176
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 91 15
        s"memv"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 107 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 107 9
        jmp _label_179
_label_178:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"alist"
        bind
        cdr
;; ----
        s"compare"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 46
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 23
        s"compare"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_180
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 44
        s"compare"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 36
        s"car"
        @
        call_in
;; --Call End--
        jmp _label_181
;; --If true--
_label_180:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 98 31
        s"equal?"
        @
;; --If Done--
_label_181:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 97 16
        s"compare"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 51
        jmp _label_183
_label_182:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"key"
        bind
        cdr
;; ----
        dup
        car
        s"b"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 49
        s"b"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 46
        s"key"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 42
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 102 37
        s"compare"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_183:
        proc _label_182
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 101 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 101 22
        s"alist"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 101 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 101 16
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 101 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 101 12
        s"member"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 100 17
        s"entry"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 107 8
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 104 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 104 13
        s"entry"
        @
        jnf _label_184
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 107 7
        #f
        jmp _label_185
;; --If true--
_label_184:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 106 16
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 106 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 106 15
        s"entry"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 106 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 106 9
        s"car"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_185:
;; --If End--
        swap ret
_label_179:
        proc _label_178
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 96 15
        s"assoc"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 24
        jmp _label_187
_label_186:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 22
        s"eq?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 18
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 13
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 110 9
        s"assoc"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_187:
        proc _label_186
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 109 15
        s"assq"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 25
        jmp _label_189
_label_188:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 23
        s"eqv?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 18
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 13
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 113 9
        s"assoc"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_189:
        proc _label_188
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 112 15
        s"assv"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 38
        jmp _label_191
_label_190:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"ls"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 37
        jmp _label_193
_label_192:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"result"
        bind
        cdr
;; ----
        dup
        car
        s"ls"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 36
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 23
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 20
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_195
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 120 31
        s"result"
        @
        jmp _label_194
_label_195:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 123 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 123 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 123 23
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 123 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 123 20
        s"pair?"
        @
        call_in
;; --Call End--
        not
        jnf _label_196
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 126 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 126 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 126 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 126 28
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 126 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 126 25
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 50
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 47
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 42
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 125 35
        s"stack-flatten"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 124 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 124 32
        s"stack-flatten"
        @
        tail_call_in
;; --Call End--
        jmp _label_194
_label_196:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 130 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 130 18
        s"else"
        @
        not
        jnf _label_197
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 33
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 26
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 131 23
        s"cons"
        @
        tail_call_in
;; --Call End--
        jmp _label_194
_label_197:
;; --Cond Fall-Through--
        ()
_label_194:
;; --Cond End--
        swap ret
_label_193:
        proc _label_192
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 117 27
        s"stack-flatten"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 35
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 32
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 28
        s"stack-flatten"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 132 13
        s"reverse"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_191:
        proc _label_190
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/lists.scm" 116 17
        s"flatten"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 78
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 33
        jmp _label_199
_label_198:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 29
        s"x"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 31
        1
        + 
        swap ret
_label_199:
        proc _label_198
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 8 21
        s"add"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 33
        jmp _label_201
_label_200:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 29
        s"x"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 31
        1
        - 
        swap ret
_label_201:
        proc _label_200
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 9 21
        s"sub"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 76
        jmp _label_203
_label_202:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"to-factory"
        bind
        cdr
;; ----
        dup
        car
        s"v-set!"
        bind
        cdr
;; ----
        dup
        car
        s"v-ref"
        bind
        cdr
;; ----
        dup
        car
        s"v-length"
        bind
        cdr
;; ----
        dup
        car
        s"at"
        bind
        cdr
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 12 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 12 28
        0
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 12 26
        s"start"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 39
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 34
        s"v-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 13 24
        s"end"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 63
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 63
        jmp _label_205
_label_204:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"sym"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 62
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 50
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 36
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 31
        s"null?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_208
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 48
        s"sym"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 16 44
        s"null?"
        @
        call_in
;; --Call End--
_label_208:
;; --Bool Operator End--
        jnf _label_206
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 50
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 45
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 39
        s"sym"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 19 35
        s"car"
        @
        call_in
;; --Call End--
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 60
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 58
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 53
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 47
        s"sym"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 43
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 20 38
        s"process-args"
        @
        tail_call_in
;; --Call End--
        jmp _label_207
;; --If true--
_label_206:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 17 23
        #t
;; --If Done--
_label_207:
;; --If End--
        swap ret
_label_205:
        proc _label_204
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 15 35
        s"process-args"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 21 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 21 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 21 44
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 21 39
;; --Quoted Start--
;; --Quoted Start--
        ()
        s"end"
        cons
        s"start"
        cons
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 21 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 21 26
        s"process-args"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 36
        s"end"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 42
        s"start"
        @
        - 
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 23 29
        s"to-copy"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 44
        s"to-copy"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 36
        s"to-factory"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 25 24
        s"to"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 71
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 71
        jmp _label_210
_label_209:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"at"
        bind
        cdr
;; ----
        dup
        car
        s"start"
        bind
        cdr
;; ----
        dup
        car
        s"dir"
        bind
        cdr
;; ----
        dup
        car
        s"num"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 70
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 28 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 28 25
        0
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 28 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 28 29
        s"num"
        @
        > 
        jnf _label_211
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 46
        s"start"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 40
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 32 35
        s"v-ref"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 31 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 31 38
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 31 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 31 35
        s"to"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 31 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 31 32
        s"v-set!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 68
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 67
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 63
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 63
        s"num"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 65
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 56
        s"dir"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 51
        s"start"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 45
        s"dir"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 39
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 36
        s"dir"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 33 31
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_212
;; --If true--
_label_211:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 29 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 29 23
        s"to"
        @
;; --If Done--
_label_212:
;; --If End--
        swap ret
_label_210:
        proc _label_209
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 27 28
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 75
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 35 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 35 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 35 26
        s"start"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 35 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 35 29
        s"at"
        @
        > 
        jnf _label_213
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 38 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 38 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 38 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 38 45
        s"to-copy"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 38 47
        1
        - 
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 38 34
        s"to-copy"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 73
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 72
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 72
        s"to-copy"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 64
        s"sub"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 60
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 51
        s"start"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 59
        s"to-copy"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 33
        s"at"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 41
        s"to-copy"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 39 27
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_214
;; --If true--
_label_213:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 47
        s"to-copy"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 49
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 36
        s"add"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 32
        s"start"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 26
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 36 23
        s"inner"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_214:
;; --If End--
        swap ret
_label_203:
        proc _label_202
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 6 27
        s"core-vector-copier"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 22
        jmp _label_216
_label_215:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"length-func"
        bind
        cdr
;; ----
        dup
        car
        s"ref-func"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 21
        jmp _label_218
_label_217:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 60
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 60
        jmp _label_220
_label_219:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        dup
        car
        s"index"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 59
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 39
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 35
        s"length-func"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 22
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 44 16
        s">="
        @
        call_in
;; --Call End--
        jnf _label_221
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 50
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 56
        s"index"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 44
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 38
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 32
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 28
        s"ref-func"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 18
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 46 12
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_222
;; --If true--
_label_221:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 45 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 45 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 45 19
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 45 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 45 14
        s"reverse"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_222:
;; --If End--
        swap ret
_label_220:
        proc _label_219
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 43 21
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 19
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 17
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 47 13
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_218:
        proc _label_217
        swap ret
_label_216:
        proc _label_215
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 41 25
        s"core-vec->list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 23
        jmp _label_224
_label_223:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"make-func"
        bind
        cdr
;; ----
        dup
        car
        s"set-func!"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 22
        jmp _label_226
_label_225:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 32
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 27
        s"length"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 52 19
        s"make-func"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 51 18
        s"vec"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 44
        jmp _label_228
_label_227:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
        cdr
;; ----
        dup
        car
        s"index"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 43
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 55 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 55 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 55 24
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 55 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 55 19
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_229
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 41
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 36
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 31
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 25
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 58 21
        s"set-func!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 33
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 39
        s"index"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 27
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 22
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 59 17
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_230
;; --If true--
_label_229:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 56 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 56 12
        s"vec"
        @
;; --If Done--
_label_230:
;; --If End--
        swap ret
_label_228:
        proc _label_227
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 54 22
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 20
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 18
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 60 13
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_226:
        proc _label_225
        swap ret
_label_224:
        proc _label_223
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/core.scm" 49 25
        s"core-list->vec"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 5 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 5 47
        jmp _label_232
_label_231:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 5 46
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 5 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 5 33
        s"x"
        @
;; ----Escape ASM End----
        vector-u8?
;; --Raw ASM End--
        swap ret
_label_232:
        proc _label_231
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 5 22
        s"bytevector?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 8 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 8 49
        jmp _label_234
_label_233:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 8 48
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 8 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 8 38
        s"x"
        @
;; ----Escape ASM End----
        vec-len
;; --Raw ASM End--
        swap ret
_label_234:
        proc _label_233
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 8 27
        s"bytevector-length"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 35
        jmp _label_236
_label_235:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 34
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 12
        s"idx"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 18
        s"obj"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 12 24
        s"vec"
        @
;; ----Escape ASM End----
        idx!
        ()
;; --Raw ASM End--
        swap ret
_label_236:
        proc _label_235
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 11 28
        s"bytevector-u8-set!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 26
        jmp _label_238
_label_237:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 25
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 12
        s"idx"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 16 18
        s"vec"
        @
;; ----Escape ASM End----
        idx@
;; --Raw ASM End--
        swap ret
_label_238:
        proc _label_237
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 15 27
        s"bytevector-u8-ref"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 37
        jmp _label_240
_label_239:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
        cdr
;; ----
        dup
        car
        s"fill"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 25 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 25 12
        jmp _label_242
_label_241:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"index"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 25 11
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 21 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 21 20
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 21 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 21 18
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 21 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 21 12
        s">="
        @
        call_in
;; --Call End--
        jnf _label_243
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 25 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 25 10
        s"vec"
        @
        jmp _label_244
;; --If true--
_label_243:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 43
        s"fill"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 38
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 32
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 23 28
        s"bytevector-u8-set!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 24
        s"index"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 26
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 24 15
        s"inner"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_244:
;; --If End--
        swap ret
_label_242:
        proc _label_241
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 20 17
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 31
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 27
        s"vector-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 34
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 26 9
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_240:
        proc _label_239
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 19 26
        s"bytevector-fill!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 37 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 37 23
        jmp _label_246
_label_245:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 31 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 31 56
        jmp _label_248
_label_247:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"k"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 31 55
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 31 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 31 43
        s"k"
        @
;; ----Escape ASM End----
        vector-u8
;; --Raw ASM End--
        swap ret
_label_248:
        proc _label_247
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 31 32
        s"make-bytevector-prim"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 37 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 37 21
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 40
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 35
        s"length"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 27
        2
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 35 25
        s"eq?"
        @
        call_in
;; --Call End--
        jnf _label_249
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 37 20
        0
        jmp _label_250
;; --If true--
_label_249:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 33
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 28
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 36 23
        s"car"
        @
        call_in
;; --Call End--
;; --If Done--
_label_250:
;; --If End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 52
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 47
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 42
        s"make-bytevector-prim"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 34 20
        s"bytevector-fill!"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_246:
        proc _label_245
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 30 25
        s"make-bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 58
        jmp _label_252
_label_251:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 61
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 61
        jmp _label_254
_label_253:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"args"
        bind
        cdr
;; ----
        dup
        car
        s"result"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 60
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 42 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 42 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 42 24
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 42 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 42 19
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_255
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 57
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 52
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 47
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 43
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 45 36
        s"bytevector-u8-set!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 52
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 56
        s"idx"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 47
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 39
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 34
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 46 29
        s"walk-vector"
        @
        tail_call_in
;; --Call End--
        jmp _label_256
;; --If true--
_label_255:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 43 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 43 19
        s"result"
        @
;; --If Done--
_label_256:
;; --If End--
        swap ret
_label_254:
        proc _label_253
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 41 25
        s"walk-vector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 56
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 52
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 47
        s"length"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 39
        s"make-bytevector"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 22
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 47 17
        s"walk-vector"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_252:
        proc _label_251
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 40 20
        s"bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 105
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 105
        jmp _label_258
_label_257:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"to-factory"
        bind
        cdr
;; ----
        dup
        car
        s"at"
        bind
        cdr
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 104
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 103
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 103
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 98
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 98
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 93
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 93
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 90
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 90
        s"bytevector-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 72
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 72
        s"bytevector-u8-ref"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 54
        s"bytevector-u8-set!"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 35
        s"to-factory"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 50 24
        s"core-vector-copier"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_258:
        proc _label_257
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 49 28
        s"bytevector-copier"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 57
        jmp _label_260
_label_259:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"to"
        bind
        cdr
;; ----
        dup
        car
        s"at"
        bind
        cdr
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 55
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 55
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 50
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 45
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 42
        jmp _label_262
_label_261:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"size"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 41
        s"to"
        @
        swap ret
_label_262:
        proc _label_261
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 54 23
        s"bytevector-copier"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_260:
        proc _label_259
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 53 26
        s"bytevector-copy!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 53
        jmp _label_264
_label_263:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 51
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 46
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 41
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 39
        s"make-bytevector"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 58 23
        s"bytevector-copier"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_264:
        proc _label_263
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 57 25
        s"bytevector-copy"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 26
        jmp _label_266
_label_265:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 75
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 75
        jmp _label_268
_label_267:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"size"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 74
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 63 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 63 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 63 24
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 63 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 63 19
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_269
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 73
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 72
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 71
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 71
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 66
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 66
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 61
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 29
        s"size"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 60
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 58
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 53
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 48
        s"bytevector-length"
        @
        call_in
;; --Call End--
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 65 21
        s"len-all"
        @
        tail_call_in
;; --Call End--
        jmp _label_270
;; --If true--
_label_269:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 64 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 64 17
        s"size"
        @
;; --If Done--
_label_270:
;; --If End--
        swap ret
_label_268:
        proc _label_267
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 62 21
        s"len-all"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 51
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 46
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 44
        s"len-all"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 35
        s"make-bytevector"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 67 18
        s"dest"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 55
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 55
        jmp _label_272
_label_271:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"dest"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 54
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 70 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 70 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 70 24
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 70 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 70 19
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_273
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 60
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 57
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 52
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 47
        s"bytevector-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 73 28
        s"len"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 53
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 48
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 43
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 39
        s"dest"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 74 34
        s"bytevector-copy!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 50
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 45
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 35
        s"idx"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 39
        s"len"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 28
        s"dest"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 75 23
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_274
;; --If true--
_label_273:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 71 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 71 17
        s"dest"
        @
;; --If Done--
_label_274:
;; --If End--
        swap ret
_label_272:
        proc _label_271
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 69 20
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 24
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 19
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 17
        s"dest"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 77 12
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_266:
        proc _label_265
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 61 27
        s"bytevector-append"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 71
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 70
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 69
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 69
        s"bytevector-u8-set!"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 50
        s"make-bytevector"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 34
        s"core-list->vec"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 79 18
        s"list->u8"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 71
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 70
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 69
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 69
        s"bytevector-u8-ref"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 51
        s"bytevector-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 33
        s"core-vec->list"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/byte-vectors.scm" 80 17
        s"u8->list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 5 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 5 40
        jmp _label_276
_label_275:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 5 39
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 5 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 5 29
        s"x"
        @
;; ----Escape ASM End----
        vector?
;; --Raw ASM End--
        swap ret
_label_276:
        proc _label_275
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 5 18
        s"vector?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 11 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 11 28
        jmp _label_278
_label_277:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 11 27
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 9 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 9 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 9 17
        s"x"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 9 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 9 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_279
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 11 26
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 11 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 11 16
        s"x"
        @
;; ----Escape ASM End----
        vec-len
;; --Raw ASM End--
        jmp _label_280
;; --If true--
_label_279:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 10 10
        0
;; --If Done--
_label_280:
;; --If End--
        swap ret
_label_278:
        proc _label_277
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 8 23
        s"vector-length"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 35
        jmp _label_282
_label_281:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 34
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 12
        s"idx"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 18
        s"obj"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 15 24
        s"vec"
        @
;; ----Escape ASM End----
        idx!
        ()
;; --Raw ASM End--
        swap ret
_label_282:
        proc _label_281
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 14 21
        s"vector-set!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 26
        jmp _label_284
_label_283:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 25
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 12
        s"idx"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 19 18
        s"vec"
        @
;; ----Escape ASM End----
        idx@
;; --Raw ASM End--
        swap ret
_label_284:
        proc _label_283
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 18 20
        s"vector-ref"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 37
        jmp _label_286
_label_285:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"vec"
        bind
        cdr
;; ----
        dup
        car
        s"fill"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 28 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 28 12
        jmp _label_288
_label_287:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"index"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 28 11
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 24 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 24 20
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 24 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 24 18
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 24 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 24 12
        s">="
        @
        call_in
;; --Call End--
        jnf _label_289
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 28 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 28 10
        s"vec"
        @
        jmp _label_290
;; --If true--
_label_289:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 36
        s"fill"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 31
        s"index"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 25
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 26 21
        s"vector-set!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 24
        s"index"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 26
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 27 15
        s"inner"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_290:
;; --If End--
        swap ret
_label_288:
        proc _label_287
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 23 17
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 31
        s"vec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 27
        s"vector-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 34
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 29 9
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_286:
        proc _label_285
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 22 22
        s"vector-fill!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 40 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 40 25
        jmp _label_292
_label_291:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 34 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 34 49
        jmp _label_294
_label_293:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"k"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 34 48
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 34 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 34 39
        s"k"
        @
;; ----Escape ASM End----
        vector
;; --Raw ASM End--
        swap ret
_label_294:
        proc _label_293
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 34 28
        s"make-vector-prim"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 40 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 40 23
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 40
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 35
        s"length"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 27
        2
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 38 25
        s"eq?"
        @
        call_in
;; --Call End--
        jnf _label_295
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 40 22
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        jmp _label_296
;; --If true--
_label_295:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 33
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 28
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 39 23
        s"car"
        @
        call_in
;; --Call End--
;; --If Done--
_label_296:
;; --If End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 44
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 39
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 34
        s"make-vector-prim"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 37 16
        s"vector-fill!"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_292:
        proc _label_291
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 33 21
        s"make-vector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 42
        s"vector-set!"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 30
        s"make-vector"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 44 18
        s"core-list->vec"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 43 21
        s"list->vector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 85
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 85
        jmp _label_298
_label_297:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"to-factory"
        bind
        cdr
;; ----
        dup
        car
        s"at"
        bind
        cdr
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 84
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 83
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 83
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 78
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 78
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 73
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 73
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 70
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 70
        s"vector-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 56
        s"vector-ref"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 45
        s"vector-set!"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 33
        s"to-factory"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 47 22
        s"core-vector-copier"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_298:
        proc _label_297
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 46 24
        s"vector-copier"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 53
        jmp _label_300
_label_299:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"to"
        bind
        cdr
;; ----
        dup
        car
        s"at"
        bind
        cdr
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 51
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 46
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 41
        s"at"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 38
        jmp _label_302
_label_301:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"size"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 37
        s"to"
        @
        swap ret
_label_302:
        proc _label_301
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 51 19
        s"vector-copier"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_300:
        proc _label_299
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 50 22
        s"vector-copy!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 45
        jmp _label_304
_label_303:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"from"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 43
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 38
        s"from"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 33
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 31
        s"make-vector"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 55 19
        s"vector-copier"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_304:
        proc _label_303
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 54 21
        s"vector-copy"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 63
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 62
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 62
        s"vector-ref"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 51
        s"vector-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 37
        s"core-vec->list"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 58 21
        s"vector->list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 23
        jmp _label_306
_label_305:
        swap
;; -- Formals --
;; ----
        s"list"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 21
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 62 16
        s"list->vector"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_306:
        proc _label_305
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/vectors/vectors.scm" 61 16
        s"vector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 7 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 7 25
        jmp _label_308
_label_307:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 7 24
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 7 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 7 14
        s"str"
        @
;; ----Escape ASM End----
        str->u8
;; --Raw ASM End--
        swap ret
_label_308:
        proc _label_307
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 6 20
        s"string->u8"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 11 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 11 24
        jmp _label_310
_label_309:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"u8"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 11 23
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 11 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 11 13
        s"u8"
        @
;; ----Escape ASM End----
        u8->str
;; --Raw ASM End--
        swap ret
_label_310:
        proc _label_309
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 10 20
        s"u8->string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 42
        jmp _label_312
_label_311:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 39
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 35
        s"string->u8"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 15 23
        s"bytevector-length"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_312:
        proc _label_311
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 14 23
        s"string-length"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 55
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 55
        jmp _label_314
_label_313:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
        cdr
;; ----
        dup
        car
        s"start"
        bind
        cdr
;; ----
        dup
        car
        s"end"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 52
        s"end"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 48
        s"start"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 41
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 37
        s"string->u8"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 20 25
        s"bytevector-copy"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 19 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 19 16
        s"u8->string"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_314:
        proc _label_313
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 18 19
        s"substring"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 47
        jmp _label_316
_label_315:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 46
;; -- Let* --
        ()
        proc _label_317
        tail_call_in
_label_317:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 44
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 40
        s"string->u8"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 28
        s"u8->list"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 31 18
        s"u8-list"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 44
        s"u8-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 36
        s"integer->char"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 33 22
        s"map"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_318:
;; -- Let* End --
        swap ret
_label_316:
        proc _label_315
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 29 23
        s"string->list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 41
        jmp _label_320
_label_319:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 37
        s"list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 32
        s"char->integer"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 38 18
        s"map"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 37 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 37 18
        s"list->u8"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 36 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 36 16
        s"u8->string"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_320:
        proc _label_319
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 35 23
        s"list->string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 44 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 44 27
        jmp _label_322
_label_321:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"num"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 44 26
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 44 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 44 14
        s"num"
        @
;; ----Escape ASM End----
        int->char
;; --Raw ASM End--
        swap ret
_label_322:
        proc _label_321
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 43 24
        s"integer->char"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 47 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 47 28
        jmp _label_324
_label_323:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"char"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 47 27
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 47 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 47 15
        s"char"
        @
;; ----Escape ASM End----
        char->int
;; --Raw ASM End--
        swap ret
_label_324:
        proc _label_323
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 46 24
        s"char->integer"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 35
        jmp _label_326
_label_325:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 34
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 55 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 55 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 55 21
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 55 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 55 16
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_328
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 55 25
        #t
        jmp _label_327
_label_328:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 57 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 57 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 57 34
        s"a"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 57 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 57 32
        s"char->integer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 42
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 37
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 58 32
        s"char->integer"
        @
        call_in
;; --Call End--
        = 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 56 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 56 14
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_329
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 59 19
        #f
        jmp _label_327
_label_329:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 60 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 60 14
        s"else"
        @
        not
        jnf _label_330
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 31
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 26
        s"char=?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 61 19
        s"apply"
        @
        tail_call_in
;; --Call End--
        jmp _label_327
_label_330:
;; --Cond Fall-Through--
        ()
_label_327:
;; --Cond End--
        swap ret
_label_326:
        proc _label_325
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 53 17
        s"char=?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 35
        jmp _label_332
_label_331:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 34
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 65 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 65 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 65 21
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 65 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 65 16
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_334
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 65 25
        #t
        jmp _label_333
_label_334:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 67 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 67 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 67 34
        s"a"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 67 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 67 32
        s"char->integer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 42
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 37
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 68 32
        s"char->integer"
        @
        call_in
;; --Call End--
        < 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 66 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 66 14
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_335
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 69 19
        #f
        jmp _label_333
_label_335:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 70 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 70 14
        s"else"
        @
        not
        jnf _label_336
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 31
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 26
        s"char<?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 71 19
        s"apply"
        @
        tail_call_in
;; --Call End--
        jmp _label_333
_label_336:
;; --Cond Fall-Through--
        ()
_label_333:
;; --Cond End--
        swap ret
_label_332:
        proc _label_331
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 63 17
        s"char<?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 36
        jmp _label_338
_label_337:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 35
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 75 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 75 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 75 21
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 75 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 75 16
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_340
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 75 25
        #t
        jmp _label_339
_label_340:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 42
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 37
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 78 32
        s"char->integer"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 35
        s"a"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 33
        s"char->integer"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 77 18
        s"<="
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 76 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 76 14
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_341
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 79 19
        #f
        jmp _label_339
_label_341:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 80 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 80 14
        s"else"
        @
        not
        jnf _label_342
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 32
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 27
        s"char<=?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 81 19
        s"apply"
        @
        tail_call_in
;; --Call End--
        jmp _label_339
_label_342:
;; --Cond Fall-Through--
        ()
_label_339:
;; --Cond End--
        swap ret
_label_338:
        proc _label_337
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 73 18
        s"char<=?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 35
        jmp _label_344
_label_343:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 34
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 85 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 85 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 85 21
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 85 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 85 16
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_346
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 85 25
        #t
        jmp _label_345
_label_346:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 87 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 87 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 87 34
        s"a"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 87 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 87 32
        s"char->integer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 42
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 37
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 88 32
        s"char->integer"
        @
        call_in
;; --Call End--
        > 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 86 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 86 14
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_347
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 89 19
        #f
        jmp _label_345
_label_347:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 90 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 90 14
        s"else"
        @
        not
        jnf _label_348
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 31
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 26
        s"char>?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 91 19
        s"apply"
        @
        tail_call_in
;; --Call End--
        jmp _label_345
_label_348:
;; --Cond Fall-Through--
        ()
_label_345:
;; --Cond End--
        swap ret
_label_344:
        proc _label_343
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 83 17
        s"char>?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 36
        jmp _label_350
_label_349:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"a"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 35
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 95 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 95 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 95 21
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 95 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 95 16
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_352
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 95 25
        #t
        jmp _label_351
_label_352:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 42
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 37
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 98 32
        s"char->integer"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 35
        s"a"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 33
        s"char->integer"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 97 18
        s">="
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 96 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 96 14
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_353
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 99 19
        #f
        jmp _label_351
_label_353:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 100 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 100 14
        s"else"
        @
        not
        jnf _label_354
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 32
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 27
        s"char>=?"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 101 19
        s"apply"
        @
        tail_call_in
;; --Call End--
        jmp _label_351
_label_354:
;; --Cond Fall-Through--
        ()
_label_351:
;; --Cond End--
        swap ret
_label_350:
        proc _label_349
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/strings.scm" 93 18
        s"char>=?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 8 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 8 22
        0
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 8 20
        s"*record-id*"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 14 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 14 11
        jmp _label_356
_label_355:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 12 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 12 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 12 30
        s"*record-id*"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 12 18
        s"type-id"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 13 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 13 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 13 25
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 13 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 13 37
        s"*record-id*"
        @
        + 
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 13 20
        s"*record-id*"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 14 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 14 10
        s"type-id"
        @
        swap ret
_label_356:
        proc _label_355
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 11 26
        s"next-record-type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 17 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 17 42
        jmp _label_358
_label_357:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 17 41
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 17 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 17 31
        s"obj"
        @
;; ----Escape ASM End----
        record?
;; --Raw ASM End--
        swap ret
_label_358:
        proc _label_357
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 17 17
        s"record?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 21 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 21 23
        jmp _label_360
_label_359:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"size"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 21 22
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 21 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 21 13
        s"size"
        @
;; ----Escape ASM End----
        record
;; --Raw ASM End--
        swap ret
_label_360:
        proc _label_359
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 20 21
        s"make-record"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 26
        jmp _label_362
_label_361:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 25
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 12
        s"idx"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 25 18
        s"rec"
        @
;; ----Escape ASM End----
        idx@
;; --Raw ASM End--
        swap ret
_label_362:
        proc _label_361
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 24 20
        s"record-ref"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 35
        jmp _label_364
_label_363:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 34
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 12
        s"idx"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 18
        s"obj"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 28 24
        s"rec"
        @
;; ----Escape ASM End----
        idx!
        ()
;; --Raw ASM End--
        swap ret
_label_364:
        proc _label_363
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 27 22
        s"record-set!"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 31 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 31 23
        jmp _label_366
_label_365:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rec"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 31 22
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 31 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 31 12
        s"rec"
        @
;; ----Escape ASM End----
        vec-len
;; --Raw ASM End--
        swap ret
_label_366:
        proc _label_365
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 30 24
        s"record-length"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 63
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 62
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 62
        s"record-ref"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 51
        s"record-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 37
        s"core-vec->list"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 34 21
        s"record->list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 32
        jmp _label_368
_label_367:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"type-id"
        bind
        cdr
;; ----
        dup
        car
        s"size"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 55
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 55
        jmp _label_370
_label_369:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rec"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"field-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 54
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 40 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 40 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 40 26
        s"field-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 40 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 40 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_371
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 45
        s"field-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 34
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 29
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 25
        s"rec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 46 21
        s"record-set!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 50
        s"field-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 39
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 29
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 33
        s"idx"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 24
        s"rec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 47 20
        s"set-values"
        @
        tail_call_in
;; --Call End--
        jmp _label_372
;; --If true--
_label_371:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 44 15
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 20
        s"idx"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 22
        1
        - 
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 41 28
        s"size"
        @
        < 
        jnf _label_373
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 44 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 44 14
        s"rec"
        @
        jmp _label_374
;; --If true--
_label_373:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 27
        s"size"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 19
        s"idx"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 43 21
        1
        - 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 42 80
        "Record constructor called with incorrect number of arguments."
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 42 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 42 17
        s"error"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_374:
;; --If End--
;; --If Done--
_label_372:
;; --If End--
        swap ret
_label_370:
        proc _label_369
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 39 22
        s"set-values"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 31
        jmp _label_376
_label_375:
        swap
;; -- Formals --
;; ----
        s"fields"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 34
        s"size"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 29
        s"make-record"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 52 16
        s"rec"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 31
        s"type-id"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 23
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 21
        s"rec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 53 17
        s"record-set!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 29
        s"fields"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 22
        1
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 20
        s"rec"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 54 16
        s"set-values"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_376:
        proc _label_375
        swap ret
_label_368:
        proc _label_367
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 37 36
        s"record-constructor-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 59
        jmp _label_378
_label_377:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"type-id"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 58
        jmp _label_380
_label_379:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 57
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 22
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 18
        s"record?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_382
        jmp _label_381
_label_382:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 54
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 52
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 48
        s"record-ref"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 36
        s"type-id"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 59 28
        s"eq?"
        @
        call_in
;; --Call End--
_label_381:
;; --Bool Operator End--
        swap ret
_label_380:
        proc _label_379
        swap ret
_label_378:
        proc _label_377
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 57 34
        s"record-predicate-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 39
        jmp _label_384
_label_383:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"idx"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 38
        jmp _label_386
_label_385:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 36
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 32
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 63 28
        s"record-ref"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_386:
        proc _label_385
        swap ret
_label_384:
        proc _label_383
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 62 31
        s"record-getter-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 52
        jmp _label_388
_label_387:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"idx"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 51
        jmp _label_390
_label_389:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
        cdr
;; ----
        dup
        car
        s"value"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 49
        s"value"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 43
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 39
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 67 35
        s"record-set!"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_390:
        proc _label_389
        swap ret
_label_388:
        proc _label_387
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 66 31
        s"record-setter-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 21
        jmp _label_392
_label_391:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"bindings"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"accessor"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 19
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 29
        s"accessor"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 20
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 73 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_393
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 77 17
        s"bindings"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 64
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 63
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 62
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 62
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 58
        s"record-setter-factory"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 33
        s"accessor"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 24
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 19
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 76 14
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 75 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 75 12
        s"cons"
        @
        call_in
;; --Call End--
        jmp _label_394
;; --If true--
_label_393:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 74 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 74 15
        s"bindings"
        @
;; --If Done--
_label_394:
;; --If End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 52
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 48
        s"record-getter-factory"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 24
        s"accessor"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 15
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 72 10
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 71 8
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 71 8
        s"cons"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_392:
        proc _label_391
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 70 30
        s"record-field-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 42
        jmp _label_396
_label_395:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"bindings"
        bind
        cdr
;; ----
        dup
        car
        s"idx"
        bind
        cdr
;; ----
        dup
        car
        s"fields"
        bind
        cdr
;; ----
        dup
        car
        s"access"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 41
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 81 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 81 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 81 20
        s"fields"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 81 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 81 13
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_397
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 35
        s"access"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 27
        s"fields"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 20
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 86 15
        s"assoc"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 85 24
        s"accessors"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 38
        s"access"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 30
        s"fields"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 23
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 13
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 92 17
        s"idx"
        @
        + 
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 63
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 89 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 89 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 89 27
        s"accessors"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 89 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 89 17
        s"not"
        @
        call_in
;; --Call End--
        jnf _label_399
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 62
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 61
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 60
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 60
        s"accessors"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 50
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 45
        s"idx"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 41
        s"bindings"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 91 32
        s"record-field-factory"
        @
        call_in
;; --Call End--
        jmp _label_400
;; --If true--
_label_399:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 90 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 90 19
        s"bindings"
        @
;; --If Done--
_label_400:
;; --If End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 88 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 88 32
        s"record-accessor-factory"
        @
        tail_call_in
;; --Call End--
        jmp _label_398
;; --If true--
_label_397:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 82 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 82 13
        s"bindings"
        @
;; --If Done--
_label_398:
;; --If End--
        swap ret
_label_396:
        proc _label_395
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 80 33
        s"record-accessor-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 77
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 77
        jmp _label_402
_label_401:
        swap
;; -- Formals --
;; ----
        s"rec-def"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 98 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 98 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 98 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 98 37
        s"next-record-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 98 19
        s"type-id"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 36
        s"rec-def"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 28
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 100 23
        s"name-clause"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 42
        s"rec-def"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 34
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 29
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 101 23
        s"const-clause"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 45
        s"rec-def"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 37
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 32
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 27
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 102 22
        s"pred-clause"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 47
        s"rec-def"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 39
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 34
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 29
        s"cdr"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 103 24
        s"fields-clause"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 46
        s"const-clause"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 33
        s"length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 49
        1
        - 
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 106 22
        s"field-count"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 114 7
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 114 6
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 81
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 80
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 79
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 79
        s"field-count"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 67
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 67
        s"type-id"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 59
        s"record-constructor-factory"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 30
        s"const-clause"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 17
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 113 12
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 60
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 58
        s"type-id"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 50
        s"record-predicate-factory"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 24
        s"pred-clause"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 112 12
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 111 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 111 10
        s"list"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 110 23
        s"binding-list"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 76
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 75
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 75
        s"fields-clause"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 61
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 60
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 60
        s"const-clause"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 47
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 42
        1
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 40
        s"binding-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 117 27
        s"record-accessor-factory"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_402:
        proc _label_401
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/records.scm" 96 29
        s"record-type-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 27
        jmp _label_404
_label_403:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 44
        jmp _label_406
_label_405:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val-list"
        bind
        cdr
;; ----
        dup
        car
        s"flat-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 43
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 14 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 14 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 14 25
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 14 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 14 16
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_407
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 40
        s"flat-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 28
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 19
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 14
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 17 9
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 24
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 15
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 16 10
        s"combind"
        @
        tail_call_in
;; --Call End--
        jmp _label_408
;; --If true--
_label_407:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 15 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 15 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 15 20
        s"flat-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 15 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 15 10
        s"reverse"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_408:
;; --If End--
        swap ret
_label_406:
        proc _label_405
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 12 19
        s"combind"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 50
        jmp _label_410
_label_409:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val-list"
        bind
        cdr
;; ----
        dup
        car
        s"new-val-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 49
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 21 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 21 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 21 22
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 21 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 21 13
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_412
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 22 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 22 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 22 28
        s"new-val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 22 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 22 15
        s"reverse"
        @
        tail_call_in
;; --Call End--
        jmp _label_411
_label_412:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 28
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 19
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 24 14
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_413
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 25 10
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        jmp _label_411
_label_413:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 27 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 27 12
        s"else"
        @
        not
        jnf _label_414
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 45
        s"new-val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 30
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 21
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 16
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 29 11
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 26
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 17
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 28 12
        s"next"
        @
        tail_call_in
;; --Call End--
        jmp _label_411
_label_414:
;; --Cond Fall-Through--
        ()
_label_411:
;; --Cond End--
        swap ret
_label_410:
        proc _label_409
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 19 17
        s"next"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 20
        jmp _label_416
_label_415:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val-list"
        bind
        cdr
;; ----
        dup
        car
        s"args-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 37
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 33
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 24
        s"next"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 33 18
        s"next-val"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 19
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 35 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 35 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 35 27
        s"next-val"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 35 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 35 18
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_417
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 17
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 39 16
        s"args-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 38 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 38 28
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 38 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 38 24
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 38 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 38 15
        s"combind"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 37 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 37 25
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 37 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 37 19
        s"next-val"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 37 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 37 10
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_418
;; --If true--
_label_417:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 36 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 36 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 36 22
        s"args-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 36 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 36 12
        s"reverse"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_418:
;; --If End--
        swap ret
_label_416:
        proc _label_415
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 32 19
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 26
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 13
        1
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 30
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 42 21
        s"length"
        @
        call_in
;; --Call End--
        = 
        jnf _label_419
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 24
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 20
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 44 11
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_420
;; --If true--
_label_419:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 43 19
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 43 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 43 18
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 43 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 43 9
        s"car"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_420:
;; --If End--
        swap ret
_label_404:
        proc _label_403
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 8 19
        s"prep-args"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 33
        jmp _label_422
_label_421:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"proc"
        bind
        cdr
;; ----
        s"val-list"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 29
        jmp _label_424
_label_423:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 28
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 53
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 28
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 19
        s"null?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_427
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 50
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 41
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 52 36
        s"null?"
        @
        call_in
;; --Call End--
_label_427:
;; --Bool Operator End--
        jnf _label_425
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 35
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 26
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 21
        s"list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 15
        s"proc"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 55 10
        s"apply"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 24
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 15
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 56 10
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_426
;; --If true--
_label_425:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 53 5
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
;; --If Done--
_label_426:
;; --If End--
        swap ret
_label_424:
        proc _label_423
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 51 18
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 30
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 21
        s"prep-args"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 58 10
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_422:
        proc _label_421
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 49 18
        s"for-each"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 38
        jmp _label_429
_label_428:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"proc"
        bind
        cdr
;; ----
        s"val-list"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 13
        jmp _label_431
_label_430:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val-list"
        bind
        cdr
;; ----
        dup
        car
        s"result"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 12
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 53
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 28
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 19
        s"null?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_434
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 50
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 41
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 65 36
        s"null?"
        @
        call_in
;; --Call End--
_label_434:
;; --Bool Operator End--
        jnf _label_432
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 11
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 10
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 70 9
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 34
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 25
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 20
        s"list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 14
        s"proc"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 69 9
        s"apply"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 68 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 68 14
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 22
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 13
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 8
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 67 8
        s"inner"
        @
        tail_call_in
;; --Call End--
        jmp _label_433
;; --If true--
_label_432:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 66 18
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 66 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 66 17
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 66 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 66 10
        s"reverse"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_433:
;; --If End--
        swap ret
_label_431:
        proc _label_430
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 64 18
        s"inner"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 36
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 31
        s"val-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 22
        s"prep-args"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 72 11
        s"inner"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_429:
        proc _label_428
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/loop.scm" 62 13
        s"map"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 5 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 5 33
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 5 29
        s"dynamic-wind-before"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 20 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 20 13
        jmp _label_436
_label_435:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"before"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
        cdr
;; ----
        dup
        car
        s"after"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 8 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 8 22
        #f
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 8 19
        s"result"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 10 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 10 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 10 41
        s"dynamic-wind-before"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 10 21
        s"capture"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 66
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 65
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 64
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 64
        s"dynamic-wind-before"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 44
        s"before"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 37
        s"cons"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 12 31
        s"dynamic-wind-before"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 13 13
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 13 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 13 12
        s"before"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 15 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 15 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 15 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 15 25
        s"thunk"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 15 18
        s"result"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 17 13
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 17 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 17 12
        s"after"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 18 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 18 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 18 38
        s"capture"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 18 30
        s"dynamic-wind-before"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 20 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 20 12
        s"result"
        @
        swap ret
_label_436:
        proc _label_435
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 7 23
        s"dynamic-wind"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 51
        jmp _label_438
_label_437:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"wrappers"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 50
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 23 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 23 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 23 24
        s"wrappers"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 23 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 23 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_439
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 38
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 33
        s"wrappers"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 24
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 26 19
        s"apply"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 46
        s"wrappers"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 37
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 27 32
        s"dynamic-wind-enter"
        @
        tail_call_in
;; --Call End--
        jmp _label_440
;; --If true--
_label_439:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 24 11
        #f
;; --If Done--
_label_440:
;; --If End--
        swap ret
_label_438:
        proc _label_437
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 22 29
        s"dynamic-wind-enter"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 32
        jmp _label_442
_label_441:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"proc"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 49
        s"dynamic-wind-before"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 29
        s"reverse"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 30 20
        s"capture"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 30
        jmp _label_444
_label_443:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"exit"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 28
        jmp _label_446
_label_445:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"val"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 35 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 35 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 35 44
        s"capture"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 35 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 35 36
        s"dynamic-wind-enter"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 26
        s"val"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 36 22
        s"exit"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_446:
        proc _label_445
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 34 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 34 18
        s"proc"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_444:
        proc _label_443
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 32 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 32 19
        s"prim-call/cc"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_442:
        proc _label_441
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 29 18
        s"call/cc"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 38 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 38 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 38 48
        s"call/cc"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/call-cc.scm" 38 40
        s"call-with-current-continuation"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 51
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 51
        jmp _label_448
_label_447:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"init"
        bind
        cdr
;; ----
        s"arg"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 11 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 11 28
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 9 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 9 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 9 23
        s"arg"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 9 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 9 19
        s"pair?"
        @
        call_in
;; --Call End--
        jnf _label_449
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 11 27
        jmp _label_452
_label_451:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"x"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 11 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 11 26
        s"x"
        @
        swap ret
_label_452:
        proc _label_451
        jmp _label_450
;; --If true--
_label_449:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 10 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 10 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 10 21
        s"arg"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 10 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 10 17
        s"car"
        @
        call_in
;; --Call End--
;; --If Done--
_label_450:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 8 22
        s"converter"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 35
        s"init"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 30
        s"converter"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 13 19
        s"value"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 50
        jmp _label_454
_label_453:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 49
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 25
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 20
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_456
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 17 34
        s"value"
        @
        jmp _label_455
_label_456:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 43
;; --Quoted Start--
        s"<param-set!>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 28
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 23
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 18 18
        s"eq?"
        @
        call_in
;; --Call End--
        not
        jnf _label_457
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 43
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 38
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 33
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 19 28
        s"value"
        !
        ()
        jmp _label_455
_label_457:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 46
;; --Quoted Start--
        s"<param-convert>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 28
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 23
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 20 18
        s"eq?"
        @
        call_in
;; --Call End--
        not
        jnf _label_458
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 21 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 21 26
        s"converter"
        @
        jmp _label_455
_label_458:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 22 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 22 18
        s"else"
        @
        not
        jnf _label_459
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 45
        "bad parameter syntax"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 23 23
        s"error"
        @
        tail_call_in
;; --Call End--
        jmp _label_455
_label_459:
;; --Cond Fall-Through--
        ()
_label_455:
;; --Cond End--
        swap ret
_label_454:
        proc _label_453
        swap ret
_label_448:
        proc _label_447
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 7 24
        s"make-parameter"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 41
        jmp _label_461
_label_460:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"param"
        bind
        cdr
;; ----
        dup
        car
        s"value"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 27 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 27 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 27 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 27 23
        s"param"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 27 16
        s"old"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 48
        s"value"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 41
;; --Quoted Start--
        s"<param-convert>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 24
        s"param"
        @
        call_in
;; --Call End--
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 28 16
        s"new"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 39
        jmp _label_463
_label_462:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 37
        s"old"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 33
;; --Quoted Start--
        s"<param-set!>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 35 19
        s"param"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_463:
        proc _label_462
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 33 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 33 14
        s"thunk"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 41
        jmp _label_465
_label_464:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 39
        s"value"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 33
;; --Quoted Start--
        s"<param-set!>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 32 19
        s"param"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_465:
        proc _label_464
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 30 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 30 19
        s"dynamic-wind"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_461:
        proc _label_460
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/parameter.scm" 26 20
        s"param-wrap"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 12 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 12 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 12 23
        jmp _label_467
_label_466:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 8 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 8 41
        "Caught exception: "
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 8 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 8 21
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 47
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 43
        s"error-object-message"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 9 21
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 10 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 10 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 10 21
        s"newline"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 49
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 45
        s"error-object-irritants"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 11 21
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 12 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 12 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 12 21
        s"newline"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_467:
        proc _label_466
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 6 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 6 20
        s"make-parameter"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 5 35
        s"current-exception-handler"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 19 40
;; --Record Start--
;; --Quoted Start--
        ()
;; --Quoted Start--
        ()
        s"error-object-irritants"
        cons
        s"irritants"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"error-object-message"
        cons
        s"message"
        cons
;; --Quoted End--
        cons
        s"error-object?"
        cons
;; --Quoted Start--
        ()
        s"irritants"
        cons
        s"message"
        cons
        s"make-error"
        cons
;; --Quoted End--
        cons
        s"<error>"
        cons
;; --Quoted End--
        s"record-type-factory"
        @
        call_in
;; --Record Binding--
_label_468:
        dup
        null?
        jnf _label_469
        dup
        car
        dup
        cdr
        swap
        car
        bind
        cdr
        jmp _label_468
_label_469:
;; --Record End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 41
        jmp _label_471
_label_470:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"message"
        bind
        cdr
;; ----
        s"irritants"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 38
        s"irritants"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 28
        s"message"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 24 20
        s"make-error"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 23 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 23 11
        s"raise"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_471:
        proc _label_470
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 22 17
        s"error"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 53
        jmp _label_473
_label_472:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 27 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 27 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 27 37
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 27 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 27 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 27 32
        s"current-exception-handler"
        @
        call_in
;; --Call End--
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 52
;; -- Let* --
        ()
        proc _label_474
        tail_call_in
_label_474:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 44
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 40
        s"error-object-message"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 29 18
        s"message"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 48
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 44
        s"error-object-irritants"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 30 20
        s"irritants"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 51
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 31
        s"message"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 32 43
        s"irritants"
        @
;; ----Escape ASM End----
        throw
;; --Raw ASM End--
;; -- Let* Body End--
        swap ret
_label_475:
;; -- Let* End --
        swap ret
_label_473:
        proc _label_472
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 26 16
        s"raise"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 39
        jmp _label_477
_label_476:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"obj"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 37
        s"obj"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 35 32
        s"current-exception-handler"
        @
        call_in
;; --Call End--
        tail_call_in
;; --Call End--
        swap ret
_label_477:
        proc _label_476
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 34 28
        s"raise-continuable"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 58
        jmp _label_479
_label_478:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"handler"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 56
        s"think"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 50
        s"hanlder"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 42
        s"current-exception-handler"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 38 16
        s"param-wrap"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_479:
        proc _label_478
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/error.scm" 37 36
        s"with-exception-handler"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 8 17
;; --Record Start--
;; --Quoted Start--
        ()
        s"eof-object?"
        cons
;; --Quoted Start--
        ()
        s"raw-eof-object"
        cons
;; --Quoted End--
        cons
        s"<eof>"
        cons
;; --Quoted End--
        s"record-type-factory"
        @
        call_in
;; --Record Binding--
_label_480:
        dup
        null?
        jnf _label_481
        dup
        car
        dup
        cdr
        swap
        car
        bind
        cdr
        jmp _label_480
_label_481:
;; --Record End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 14 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 14 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 14 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 14 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 14 21
        s"raw-eof-object"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 13 25
        jmp _label_483
_label_482:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"eof"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 13 24
        jmp _label_485
_label_484:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 13 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 13 23
        s"eof"
        @
        swap ret
_label_485:
        proc _label_484
        swap ret
_label_483:
        proc _label_482
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 11 19
        s"eof-object"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 24 33
;; --Record Start--
;; --Quoted Start--
        ()
;; --Quoted Start--
        ()
        s"port-type-flusher"
        cons
        s"flusher"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-type-closer"
        cons
        s"closer"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-type-reader"
        cons
        s"reader"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-type-writer"
        cons
        s"writer"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-type-binary?"
        cons
        s"binary"
        cons
;; --Quoted End--
        cons
        s"port-type?"
        cons
;; --Quoted Start--
        ()
        s"flusher"
        cons
        s"closer"
        cons
        s"reader"
        cons
        s"writer"
        cons
        s"binary"
        cons
        s"make-port-ops"
        cons
;; --Quoted End--
        cons
        s"<port-ops>"
        cons
;; --Quoted End--
        s"record-type-factory"
        @
        call_in
;; --Record Binding--
_label_486:
        dup
        null?
        jnf _label_487
        dup
        car
        dup
        cdr
        swap
        car
        bind
        cdr
        jmp _label_486
_label_487:
;; --Record End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 33 22
;; --Record Start--
;; --Quoted Start--
        ()
;; --Quoted Start--
        ()
        s"port-type"
        cons
        s"type"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-set-open!"
        cons
        s"port-open?"
        cons
        s"open"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-writable"
        cons
        s"writable"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"port-fd"
        cons
        s"fd"
        cons
;; --Quoted End--
        cons
        s"port?"
        cons
;; --Quoted Start--
        ()
        s"type"
        cons
        s"open"
        cons
        s"writable"
        cons
        s"fd"
        cons
        s"make-port"
        cons
;; --Quoted End--
        cons
        s"<port>"
        cons
;; --Quoted End--
        s"record-type-factory"
        @
        call_in
;; --Record Binding--
_label_488:
        dup
        null?
        jnf _label_489
        dup
        car
        dup
        cdr
        swap
        car
        bind
        cdr
        jmp _label_488
_label_489:
;; --Record End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 32
        jmp _label_491
_label_490:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 29
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 24
        s"port-writable"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 42 9
        s"not"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_491:
        proc _label_490
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 41 21
        s"input-port?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 26
        jmp _label_493
_label_492:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 24
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 46 19
        s"port-writable"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_493:
        proc _label_492
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 45 22
        s"output-port?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 29
        jmp _label_495
_label_494:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 28
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 49 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 49 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 49 28
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 49 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 49 23
        s"output-port?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_497
        jmp _label_496
_label_497:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 26
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 50 21
        s"port-open?"
        @
        call_in
;; --Call End--
_label_496:
;; --Bool Operator End--
        swap ret
_label_495:
        proc _label_494
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 48 28
        s"output-port-open?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 29
        jmp _label_499
_label_498:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 28
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 53 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 53 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 53 27
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 53 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 53 22
        s"input-port?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_501
        jmp _label_500
_label_501:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 26
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 54 21
        s"port-open?"
        @
        call_in
;; --Call End--
_label_500:
;; --Bool Operator End--
        swap ret
_label_499:
        proc _label_498
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 52 27
        s"input-port-open?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 46
        jmp _label_503
_label_502:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 33
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 28
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 58 17
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 43
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 38
        s"port-type-binary?"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 19
;; --Quoted Start--
        s"<binary>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 59 9
        s"eq?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_503:
        proc _label_502
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 57 22
        s"binary-port?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 47
        jmp _label_505
_label_504:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 33
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 28
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 62 17
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 44
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 39
        s"port-type-binary?"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 20
;; --Quoted Start--
        s"<textual>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 63 9
        s"eq?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_505:
        proc _label_504
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 61 24
        s"textual-port?"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 22
        jmp _label_507
_label_506:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 21
;; -- Let* --
        ()
        proc _label_508
        tail_call_in
_label_508:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 31
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 26
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 71 15
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 40
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 35
        s"port-type-closer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 72 17
        s"closer"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 27
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 22
        s"port-fd"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 73 13
        s"fd"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 75 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 75 41
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 75 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 75 38
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 75 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 75 33
        s"port-set-open!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 20
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 19
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 76 16
        s"closer"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_509:
;; -- Let* End --
        swap ret
_label_507:
        proc _label_506
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 69 21
        s"close-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 78 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 78 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 78 37
        s"close-port"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 78 26
        s"close-input-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 79 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 79 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 79 37
        s"close-port"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 79 26
        s"close-output-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 33
        jmp _label_511
_label_510:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 32
;; -- Let* --
        ()
        proc _label_512
        tail_call_in
_label_512:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 28
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 88 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 88 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 88 28
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 88 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 88 23
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_514
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 26
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 90 21
        s"car"
        @
        call_in
;; --Call End--
        jmp _label_515
;; --If true--
_label_514:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 89 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 89 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 89 37
        s"current-output-port"
        @
        call_in
;; --Call End--
;; --If Done--
_label_515:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 87 15
        s"port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 31
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 26
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 91 15
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 92 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 92 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 92 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 92 41
        s"port-type-flushertype"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 92 18
        s"flusher"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 27
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 22
        s"port-fd"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 93 13
        s"fd"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 30
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 95 27
        s"flusher"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_513:
;; -- Let* End --
        swap ret
_label_511:
        proc _label_510
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 85 28
        s"flush-output-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 124 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 124 17
        jmp _label_517
_label_516:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"len-func"
        bind
        cdr
;; ----
        dup
        car
        s"slicer"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 68
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 68
        jmp _label_519
_label_518:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"u8"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 103 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 103 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 103 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 103 42
        s"current-output-port"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 103 21
        s"port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 104 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 104 24
        0
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 104 22
        s"start"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 33
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 30
        s"len-func"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 105 20
        s"end"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 59
        jmp _label_521
_label_520:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"sym"
        bind
        cdr
;; ----
        dup
        car
        s"args"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 58
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 46
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 32
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 27
        s"null?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_524
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 44
        s"sym"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 108 40
        s"null?"
        @
        call_in
;; --Call End--
_label_524:
;; --Bool Operator End--
        jnf _label_522
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 46
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 41
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 35
        s"sym"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 111 31
        s"car"
        @
        call_in
;; --Call End--
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 54
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 49
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 43
        s"sym"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 39
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 112 34
        s"process-args"
        @
        tail_call_in
;; --Call End--
        jmp _label_523
;; --If true--
_label_522:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 109 19
        #t
;; --If Done--
_label_523:
;; --If End--
        swap ret
_label_521:
        proc _label_520
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 107 31
        s"process-args"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 113 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 113 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 113 45
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 113 40
;; --Quoted Start--
;; --Quoted Start--
        ()
        s"end"
        cons
        s"start"
        cons
        s"port"
        cons
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 113 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 113 22
        s"process-args"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 47
        s"end"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 43
        s"start"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 37
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 34
        s"slicer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 115 26
        s"u8-slice"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 67
;; -- Let* --
        ()
        proc _label_525
        tail_call_in
_label_525:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 35
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 30
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 119 19
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 44
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 39
        s"port-type-writer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 120 21
        s"writer"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 31
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 26
        s"port-fd"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 121 17
        s"fd"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 66
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 65
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 65
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 62
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 61
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 61
        s"u8-slice"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 52
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 52
        s"len-func"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 42
        s"u8-slice"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 123 33
        s"writer"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_526:
;; -- Let* End --
        swap ret
_label_519:
        proc _label_518
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 102 26
        s"write-slice"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 124 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 124 16
        s"write-slice"
        @
        swap ret
_label_517:
        proc _label_516
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 100 24
        s"writer-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 28
        jmp _label_528
_label_527:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"len-func"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 27
        jmp _label_530
_label_529:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"k"
        bind
        cdr
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 131 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 131 38
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 32
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 27
        s"length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 129 35
        0
        > 
        jnf _label_531
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 131 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 131 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 131 36
        s"current-input-port"
        @
        call_in
;; --Call End--
        jmp _label_532
;; --If true--
_label_531:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 130 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 130 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 130 26
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 130 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 130 21
        s"car"
        @
        call_in
;; --Call End--
;; --If Done--
_label_532:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 128 21
        s"port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 48
;; -- Let* --
        call _label_533
        jmp _label_534
_label_533:
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 39
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 34
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 135 23
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 48
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 43
        s"port-type-reader"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 136 25
        s"reader"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 35
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 30
        s"port-fd"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 137 21
        s"fd"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 46
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 43
        s"k"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 139 41
        s"reader"
        @
        call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_534:
;; -- Let* End --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 133 28
        s"value-read"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 26
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 37
        s"value-read"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 26
        s"len-func"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 141 40
        0
        > 
        jnf _label_535
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 143 24
        s"eof-object"
        @
        tail_call_in
;; --Call End--
        jmp _label_536
;; --If true--
_label_535:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 142 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 142 23
        s"value-read"
        @
;; --If Done--
_label_536:
;; --If End--
        swap ret
_label_530:
        proc _label_529
        swap ret
_label_528:
        proc _label_527
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 126 25
        s"reader-factory"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 40
        jmp _label_538
_label_537:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
        cdr
;; ----
        dup
        car
        s"proc"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 38
        jmp _label_540
_label_539:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 36
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 149 31
        s"close-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_540:
        proc _label_539
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 148 32
        jmp _label_542
_label_541:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 148 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 148 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 148 30
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 148 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 148 25
        s"proc"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_542:
        proc _label_541
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 147 20
        jmp _label_544
_label_543:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
        ()
        swap ret
_label_544:
        proc _label_543
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 146 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 146 18
        s"dynamic-wind"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_538:
        proc _label_537
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 145 25
        s"call-with-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 58
        jmp _label_546
_label_545:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 56
        jmp _label_548
_label_547:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 54
        s"thunk"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 48
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 43
        s"current-input-port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 154 24
        s"param-wrap"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_548:
        proc _label_547
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 152 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 152 25
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 152 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 152 20
        s"call-with-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_546:
        proc _label_545
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 151 26
        s"with-input-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 59
        jmp _label_550
_label_549:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 57
        jmp _label_552
_label_551:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 55
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 55
        s"thunk"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 49
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 44
        s"current-output-port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 159 24
        s"param-wrap"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_552:
        proc _label_551
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 157 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 157 25
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 157 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 157 20
        s"call-with-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_550:
        proc _label_549
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/core.scm" 156 27
        s"with-output-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 8 8
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 8 8
        jmp _label_554
_label_553:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"path"
        bind
        cdr
;; ----
        dup
        car
        s"write"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 7 44
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 7 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 7 15
        s"path"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 7 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 7 23
        s"write"
        @
;; ----Escape ASM End----
        open
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 7 34
;; --Quoted Start--
        s"fd"
;; --Quoted End--
;; ----Escape ASM End----
        bind
        ()
;; --Raw ASM End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 8 7
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 8 7
        s"fd"
        @
        swap ret
_label_554:
        proc _label_553
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 6 18
        s"raw-open"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 12 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 12 25
        jmp _label_556
_label_555:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 12 24
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 12 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 12 13
        s"fd"
        @
;; ----Escape ASM End----
        close
        ()
;; --Raw ASM End--
        swap ret
_label_556:
        proc _label_555
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 11 19
        s"raw-close"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 17 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 17 13
        jmp _label_558
_label_557:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"u8"
        bind
        cdr
;; ----
        dup
        car
        s"num"
        bind
        cdr
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 51
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 13
        s"u8"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 19
        s"num"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 24
        s"fd"
        @
;; ----Escape ASM End----
        write
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 16 41
;; --Quoted Start--
        s"written"
;; --Quoted End--
;; ----Escape ASM End----
        bind
        ()
;; --Raw ASM End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 17 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 17 12
        s"written"
        @
        swap ret
_label_558:
        proc _label_557
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 15 19
        s"raw-write"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 22 10
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 22 10
        jmp _label_560
_label_559:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"num"
        bind
        cdr
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 21 42
;; --Raw ASM Start--
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 21 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 21 14
        s"num"
        @
;; ----Escape ASM End----
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 21 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 21 19
        s"fd"
        @
;; ----Escape ASM End----
        read
;; ----Escape ASM Start----
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 21 32
;; --Quoted Start--
        s"read"
;; --Quoted End--
;; ----Escape ASM End----
        bind
        ()
;; --Raw ASM End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 22 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 22 9
        s"read"
        @
        swap ret
_label_560:
        proc _label_559
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 20 18
        s"raw-read"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 32
        jmp _label_562
_label_561:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 29
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 24
        s"port-fd"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 26 15
        s"raw-close"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_562:
        proc _label_561
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 25 27
        s"binary-close-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 35 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 35 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 35 27
        jmp _label_564
_label_563:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 35 26
        #t
        swap ret
_label_564:
        proc _label_563
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 34 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 34 18
        s"raw-close"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 33 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 33 17
        s"raw-read"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 32 18
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 32 18
        s"raw-write"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 31 18
;; --Quoted Start--
        s"<binary>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 30 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 30 19
        s"make-port-ops"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 29 27
        s"<binary-file-port>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 48
        jmp _label_566
_label_565:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"fd"
        bind
        cdr
;; ----
        dup
        car
        s"writable"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 46
        s"<binary-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 27
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 24
        s"writable"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 15
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 12
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 39 12
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_566:
        proc _label_565
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 38 26
        s"make-binary-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 46
        jmp _label_568
_label_567:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"file"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 44
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 40
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 37
        s"file"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 32
        s"raw-open"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 46 22
        s"make-binary-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_568:
        proc _label_567
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 45 34
        s"open-binary-output-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 46
        jmp _label_570
_label_569:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"file"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 44
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 40
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 37
        s"file"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 32
        s"raw-open"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 49 22
        s"make-binary-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_570:
        proc _label_569
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 48 33
        s"open-binary-input-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 54
        s"bytevector-copy"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 38
        s"bytevector-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 56 20
        s"writer-factory"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 55 25
        s"write-bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 59 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 59 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 59 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 59 38
        s"bytevector-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 59 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 59 20
        s"reader-factory"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/binary.scm" 58 25
        s"read-bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 49 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 39
        jmp _label_572
_label_571:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
        cdr
;; ----
        dup
        car
        s"num"
        bind
        cdr
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 38
;; -- Let* --
        ()
        proc _label_573
        tail_call_in
_label_573:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 37
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 34
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 19 23
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 48
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 43
        s"port-type-writer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 20 25
        s"writer"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 38
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 35
        s"port-fd"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 21 26
        s"real-fd"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 37
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 33
        s"string->u8"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 22 21
        s"u8"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 36
        s"real-fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 28
        s"num"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 24
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 24 21
        s"writer"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_574:
;; -- Let* End --
        swap ret
_label_572:
        proc _label_571
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 17 28
        s"text-write"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 65
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 65
        jmp _label_576
_label_575:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"num"
        bind
        cdr
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 64
;; -- Let* --
        ()
        proc _label_577
        tail_call_in
_label_577:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 37
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 34
        s"port-type"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 31 23
        s"type"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 48
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 43
        s"port-type-reader"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 32 25
        s"reader"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 38
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 35
        s"port-fd"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 33 26
        s"real-fd"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 63
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 62
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 61
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 61
        s"real-fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 53
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 53
        s"num"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 49
        s"reader"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 35 41
        s"u8->string"
        @
        tail_call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_578:
;; -- Let* End --
        swap ret
_label_576:
        proc _label_575
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 29 27
        s"text-read"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 29
        jmp _label_580
_label_579:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 27
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 39 24
        s"close-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_580:
        proc _label_579
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 38 28
        s"text-close"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 36
        jmp _label_582
_label_581:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 34
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 42 31
        s"flush-output-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_582:
        proc _label_581
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 41 29
        s"text-flush"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 49 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 49 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 49 23
        s"text-flush"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 48 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 48 23
        s"text-close"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 47 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 47 22
        s"text-read"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 46 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 46 23
        s"text-write"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 45 23
;; --Quoted Start--
        s"<textual>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 44 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 44 24
        s"make-port-ops"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 11 28
        s"<textual-file-port>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 60 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 60 30
        jmp _label_584
_label_583:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"file"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 60 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 60 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 60 28
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 59 11
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 58 11
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 57 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 57 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 57 38
        s"file"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 57 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 57 33
        s"open-binary-output-file"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 56 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 56 15
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_584:
        proc _label_583
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 55 27
        s"open-output-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 67 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 67 30
        jmp _label_586
_label_585:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"file"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 67 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 67 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 67 28
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 66 11
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 65 11
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 64 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 64 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 64 37
        s"file"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 64 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 64 32
        s"open-binary-input-file"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 63 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 63 15
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_586:
        proc _label_585
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 62 26
        s"open-input-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 75 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 75 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 75 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 75 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 75 32
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 74 15
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 73 15
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 72 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 72 35
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 72 32
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 72 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 72 30
        s"make-binary-port"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 71 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 71 19
        s"make-port"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 70 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 70 20
        s"make-parameter"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 69 28
        s"current-input-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 83 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 83 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 83 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 83 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 83 32
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 82 15
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 81 15
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 80 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 80 35
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 80 32
        1
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 80 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 80 30
        s"make-binary-port"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 79 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 79 19
        s"make-port"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 78 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 78 20
        s"make-parameter"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 77 29
        s"current-output-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 91 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 91 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 91 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 91 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 91 32
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 90 15
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 89 15
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 88 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 88 35
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 88 32
        2
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 88 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 88 30
        s"make-binary-port"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 87 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 87 19
        s"make-port"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 86 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 86 20
        s"make-parameter"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 85 28
        s"current-error-port"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 46
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 44
        s"substring"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 34
        s"string-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 97 20
        s"writer-factory"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 96 21
        s"write-string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 100 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 100 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 100 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 100 34
        s"string-length"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 100 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 100 20
        s"reader-factory"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 99 21
        s"read-string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 49
        jmp _label_588
_label_587:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
        cdr
;; ----
        dup
        car
        s"proc"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 47
        s"proc"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 41
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 37
        s"open-input-file"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 103 20
        s"call-with-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_588:
        proc _label_587
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 102 31
        s"call-with-input-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 50
        jmp _label_590
_label_589:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
        cdr
;; ----
        dup
        car
        s"proc"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 48
        s"proc"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 42
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 38
        s"open-output-file"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 106 20
        s"call-with-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_590:
        proc _label_589
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 105 32
        s"call-with-output-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 58
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 58
        jmp _label_592
_label_591:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 56
        jmp _label_594
_label_593:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 54
        s"thunk"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 48
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 48
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 43
        s"current-input-port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 111 24
        s"param-wrap"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_594:
        proc _label_593
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 109 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 109 30
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 109 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 109 26
        s"call-with-input-file"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_592:
        proc _label_591
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 108 31
        s"with-input-from-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 59
        jmp _label_596
_label_595:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
        cdr
;; ----
        dup
        car
        s"thunk"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 57
        jmp _label_598
_label_597:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 55
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 55
        s"thunk"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 49
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 44
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 44
        s"current-output-port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 116 24
        s"param-wrap"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_598:
        proc _label_597
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 114 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 114 31
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 114 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 114 27
        s"call-with-output-file"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_596:
        proc _label_595
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/textual.scm" 113 30
        s"with-output-to-file"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 9 9
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 9 9
        jmp _label_600
_label_599:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"u8"
        bind
        cdr
;; ----
        dup
        car
        s"num"
        bind
        cdr
;; ----
        dup
        car
        s"fd"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 50
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 47
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 41
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 41
        s"num"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 37
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 35
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 32
        s"bytevector-copy"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 8 15
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 7 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 7 17
        s"fd"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 7 14
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 7 14
        s"set-car!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 9 8
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 9 8
        s"num"
        @
        swap ret
_label_600:
        proc _label_599
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 6 26
        s"mem-binary-write"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 54
        jmp _label_602
_label_601:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"num"
        bind
        cdr
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 29
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 24
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 12 19
        s"offset"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 25
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 20
        s"cdr"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 13 15
        s"u8"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 45
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 42
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 42
        s"bytevector-length"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 14 23
        s"max-offset"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 33
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 33
        s"offset"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 37
        s"num"
        @
        + 
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 15 23
        s"new-offset"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 18 38
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 17 35
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 17 23
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 17 23
        s"new-offset"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 17 34
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 17 34
        s"max-offset"
        @
        > 
        jnf _label_603
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 18 38
        ()
        jmp _label_604
;; --If true--
_label_603:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 18 37
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 18 36
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 18 36
        s"max-offset"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 18 25
        s"new-offset"
        !
        ()
;; --If Done--
_label_604:
;; --If End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 53
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 31
        s"max-offset"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 20
        s"offset"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 13
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 20 13
        s">="
        @
        call_in
;; --Call End--
        jnf _label_605
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 38
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 38
        s"new-offset"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 27
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 27
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 23 22
        s"set-car!"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 50
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 50
        s"new-offset"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 39
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 39
        s"offset"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 32
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 24 29
        s"bytevector-copy"
        @
        tail_call_in
;; --Call End--
        jmp _label_606
;; --If true--
_label_605:
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 21 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 21 20
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 21 20
        s"bytevector"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_606:
;; --If End--
        swap ret
_label_602:
        proc _label_601
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 11 27
        s"mem-binary-read"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 32 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 32 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 32 27
        jmp _label_608
_label_607:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 32 26
        #t
        swap ret
_label_608:
        proc _label_607
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 31 27
        jmp _label_610
_label_609:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 31 26
        #t
        swap ret
_label_610:
        proc _label_609
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 30 24
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 30 24
        s"mem-binary-read"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 29 25
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 29 25
        s"mem-binary-write"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 28 18
;; --Quoted Start--
        s"<binary>"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 27 19
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 27 19
        s"make-port-ops"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 26 30
        s"<binary-memory-port>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 56
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 56
        jmp _label_612
_label_611:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"u8"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 54
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 54
        s"<binary-memory-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 33
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 30
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 26
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 26
        s"u8"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 23
        0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 21
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 39 15
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_612:
        proc _label_611
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 38 32
        s"open-input-bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 59
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 59
        jmp _label_614
_label_613:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 57
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 57
        s"<binary-memory-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 36
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 33
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 29
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 25
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 21
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 21
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 42 15
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_614:
        proc _label_613
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 41 33
        s"open-output-bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 45
        jmp _label_616
_label_615:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"out-port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 40
        s"out-port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 31
        s"port-fd"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 22
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 22
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 17
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 46 17
        s"reverse"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 45 29
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 45 29
        s"bytevector-append"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 45 11
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 45 11
        s"apply"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_616:
        proc _label_615
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 44 32
        s"get-output-bytevector"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 57 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 57 30
        jmp _label_618
_label_617:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 57 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 57 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 57 28
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 56 11
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 55 11
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 47
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 47
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 43
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 43
        s"string->u8"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 54 31
        s"open-input-bytevector"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 53 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 53 15
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_618:
        proc _label_617
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 52 28
        s"open-input-string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 64 30
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 64 30
        jmp _label_620
_label_619:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 64 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 64 28
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 64 28
        s"<textual-file-port>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 63 11
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 62 11
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 61 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 61 32
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 61 32
        s"open-output-bytevector"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 60 15
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 60 15
        s"make-port"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_620:
        proc _label_619
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 59 29
        s"open-output-string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 49
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 49
        jmp _label_622
_label_621:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"port"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 45
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 45
        s"port"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 40
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 40
        s"port-fd"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 31
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 68 31
        s"get-output-bytevector"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 67 16
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 67 16
        s"u8->string"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_622:
        proc _label_621
.file "/Users/jules/code/scheme_projects/insomniac/src/lib/ports/memory.scm" 66 28
        s"get-output-string"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 40 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 40 15
        jmp _label_624
_label_623:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"blk-size"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 9 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 9 23
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 9 19
        s"stream"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 16 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 16 23
        jmp _label_626
_label_625:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 16 22
;; -- Let* --
        ()
        proc _label_627
        tail_call_in
_label_627:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 40
        s"blk-size"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 31
        s"read-string"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 13 18
        s"str"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 16 21
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 14 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 14 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 14 29
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 14 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 14 25
        s"string?"
        @
        call_in
;; --Call End--
        jnf _label_629
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 16 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 16 20
        s"str"
        @
        jmp _label_630
;; --If true--
_label_629:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 15 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 15 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 15 34
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 15 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 15 30
        s"string->list"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_630:
;; --If End--
;; -- Let* Body End--
        swap ret
_label_628:
;; -- Let* End --
        swap ret
_label_626:
        proc _label_625
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 11 25
        s"read-block"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 39 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 39 26
        jmp _label_632
_label_631:
        swap
;; -- Formals --
;; ----
        s"args"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 39 25
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 30
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 25
        s"null?"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 21 18
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_634
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 55
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 53
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 53
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 45
        s"args"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 40
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 35
        s"cons"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 22 29
        s"stream"
        !
        ()
        jmp _label_633
_label_634:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 33
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 26
        s"eof-object?"
        @
        call_in
;; --Call End--
        not
        jnf _label_635
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 25 41
        s"stream"
        @
        jmp _label_633
_label_635:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 28 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 28 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 28 27
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 28 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 28 20
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_636
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 30 47
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 30 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 30 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 30 45
        s"read-block"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 30 33
        s"stream"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 31 43
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 31 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 31 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 31 41
        s"next-char"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 31 30
        s"c"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 32 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 32 22
        s"c"
        @
        jmp _label_633
_label_636:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 35 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 35 18
        s"else"
        @
        not
        jnf _label_637
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 44
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 42
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 35
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 37 30
        s"c"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 47
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 45
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 38
        s"cdr"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 38 33
        s"stream"
        !
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 39 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 39 22
        s"c"
        @
        jmp _label_633
_label_637:
;; --Cond Fall-Through--
        ()
_label_633:
;; --Cond End--
        swap ret
_label_632:
        proc _label_631
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 18 24
        s"next-char"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 40 14
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 40 14
        s"next-char"
        @
        swap ret
_label_624:
        proc _label_623
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 8 21
        s"char-stream"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 25
        jmp _label_639
_label_638:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 36
        jmp _label_641
_label_640:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"ls"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 44 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 44 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 44 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 44 27
        s"stream"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 44 19
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 35
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 45 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 45 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 45 28
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 45 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 45 25
        s"eof-object?"
        @
        call_in
;; --Call End--
        jnf _label_642
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 32
        s"ls"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 29
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 26
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 47 20
        s"walker"
        @
        tail_call_in
;; --Call End--
        jmp _label_643
;; --If true--
_label_642:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 46 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 46 15
        s"ls"
        @
;; --If Done--
_label_643:
;; --If End--
        swap ret
_label_641:
        proc _label_640
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 43 20
        s"walker"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 23
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 16
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 48 12
        s"walker"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_639:
        proc _label_638
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/stream.scm" 42 22
        s"stream-all"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 20 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 20 28
        jmp _label_645
_label_644:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"predicate"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 20 27
        jmp _label_647
_label_646:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 9 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 9 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 9 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 9 27
        s"stream"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 9 19
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 20 26
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 11 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 11 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 11 29
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 11 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 11 26
        s"eof-object?"
        @
        call_in
;; --Call End--
        not
        jnf _label_649
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 13 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 13 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 13 31
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 13 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 13 28
        s"stream"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 14 23
        #f
        jmp _label_648
_label_649:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 27
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 24
        s"predicate"
        @
        call_in
;; --Call End--
        not
        jnf _label_650
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 15 31
        s"ch"
        @
        jmp _label_648
_label_650:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 17 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 17 19
        s"else"
        @
        not
        jnf _label_651
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 19 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 19 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 19 31
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 19 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 19 28
        s"stream"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 20 23
        #f
        jmp _label_648
_label_651:
;; --Cond Fall-Through--
        ()
_label_648:
;; --Cond End--
        swap ret
_label_647:
        proc _label_646
        swap ret
_label_645:
        proc _label_644
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 7 14
        s"rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 30
        jmp _label_653
_label_652:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"result"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 27
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 25 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 25 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 25 27
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 25 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 25 20
        s"pair?"
        @
        call_in
;; --Call End--
        jnf _label_654
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 25
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 27 18
        s"list"
        @
        call_in
;; --Call End--
        jmp _label_655
;; --If true--
_label_654:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 26 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 26 19
        s"result"
        @
;; --If Done--
_label_655:
;; --If End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 24 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 24 22
        s"reverse"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 24 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 24 13
        s"flatten"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_653:
        proc _label_652
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 23 25
        s"normalize-chain"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 54 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 54 28
        jmp _label_657
_label_656:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"result"
        bind
        cdr
;; ----
        dup
        car
        s"rule-list"
        bind
        cdr
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 54 27
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 31 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 31 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 31 25
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 31 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 31 15
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_658
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 40
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 30
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 37 25
        s"rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 36
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 29
        s"rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 38 23
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 54 25
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 41 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 41 19
        s"ch"
        @
        jnf _label_660
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 61
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 60
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 58
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 58
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 51
        s"normalize-chain"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 53 34
        s"reverse"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 52 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 52 37
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 52 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 52 30
        s"for-each"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 54 23
        #f
        jmp _label_661
;; --If true--
_label_660:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 46 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 46 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 46 27
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 45 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 45 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 45 35
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 45 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 45 25
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 36
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 29
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 44 26
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 43 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 43 35
        s"chain-rule-walker"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_661:
;; --If End--
        jmp _label_659
;; --If true--
_label_658:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 33 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 33 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 33 32
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 33 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 33 25
        s"normalize-chain"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_659:
;; --If End--
        swap ret
_label_657:
        proc _label_656
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 30 27
        s"chain-rule-walker"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 51
        jmp _label_663
_label_662:
        swap
;; -- Formals --
;; ----
        s"rule-list"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 50
        jmp _label_665
_label_664:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 48
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 48
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 41
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 31
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 60 27
        s"chain-rule-walker"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_665:
        proc _label_664
        swap ret
_label_663:
        proc _label_662
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 58 20
        s"chain-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 30
        jmp _label_667
_label_666:
        swap
;; -- Formals --
;; ----
        s"rule-list"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 29
        jmp _label_669
_label_668:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 58
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 58
        jmp _label_671
_label_670:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rule-list"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 57
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 66 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 66 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 66 33
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 66 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 66 23
        s"null?"
        @
        call_in
;; --Call End--
        jnf _label_672
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 50
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 48
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 48
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 38
        s"car"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 69 33
        s"rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 46
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 44
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 44
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 37
        s"rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 70 31
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 55
;; --Cond Start--
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 75 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 75 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 75 35
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 75 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 75 32
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_675
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 80 42
;; -- Let* --
        ()
        proc _label_676
        tail_call_in
_label_676:
        swap drop
;; -- Binding List--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 64
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 63
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 62
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 61
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 61
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 51
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 46
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 46
        s"walker"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 77 38
        s"try"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 80 41
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 78 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 78 48
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 78 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 78 45
        s"try"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 78 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 78 41
        s"eq?"
        @
        call_in
;; --Call End--
        jnf _label_678
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 80 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 80 40
        s"try"
        @
        jmp _label_679
;; --If true--
_label_678:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 79 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 79 39
        s"ch"
        @
;; --If Done--
_label_679:
;; --If End--
;; -- Let* Body End--
        swap ret
_label_677:
;; -- Let* End --
        jmp _label_674
_label_675:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 81 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 81 28
        s"ch"
        @
        not
        jnf _label_680
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 81 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 81 31
        s"ch"
        @
        jmp _label_674
_label_680:
;; ----Cond Clause----
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 82 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 82 30
        s"else"
        @
        not
        jnf _label_681
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 51
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 41
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 83 36
        s"walker"
        @
        tail_call_in
;; --Call End--
        jmp _label_674
_label_681:
;; --Cond Fall-Through--
        ()
_label_674:
;; --Cond End--
        jmp _label_673
;; --If true--
_label_672:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 67 19
        #f
;; --If Done--
_label_673:
;; --If End--
        swap ret
_label_671:
        proc _label_670
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 65 24
        s"walker"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 27
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 85 17
        s"walker"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_669:
        proc _label_668
        swap ret
_label_667:
        proc _label_666
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 63 17
        s"or-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 35
        jmp _label_683
_label_682:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"result"
        bind
        cdr
;; ----
        dup
        car
        s"rule"
        bind
        cdr
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 28
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 21
        s"rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 90 15
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 34
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 40
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 34
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 31
        s"eof-object?"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 18
        s"not"
        @
        call_in
;; --Call End--
        dup
        jnf _label_687
        jmp _label_686
_label_687:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 91 39
        s"ch"
        @
_label_686:
;; --Bool Operator End--
        jnf _label_684
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 32
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 93 25
        s"normalize-chain"
        @
        tail_call_in
;; --Call End--
        jmp _label_685
;; --If true--
_label_684:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 52
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 52
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 45
        s"rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 39
        s"result"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 32
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 29
        s"cons"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 92 23
        s"*-rule-walker"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_685:
;; --If End--
        swap ret
_label_683:
        proc _label_682
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 89 23
        s"*-rule-walker"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 42
        jmp _label_689
_label_688:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rule"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 41
        jmp _label_691
_label_690:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 39
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 32
        s"rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 27
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 98 23
        s"*-rule-walker"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_691:
        proc _label_690
        swap ret
_label_689:
        proc _label_688
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 96 16
        s"*-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 24
        jmp _label_693
_label_692:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rule"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 21
        s"rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 104 16
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 103 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 103 13
        s"rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 102 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 102 16
        s"chain-rule"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_693:
        proc _label_692
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 101 16
        s"+-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 112 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 112 19
        jmp _label_695
_label_694:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rule"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 112 18
        jmp _label_697
_label_696:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 32
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 25
        s"rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 109 19
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 112 17
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 110 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 110 15
        s"ch"
        @
        jnf _label_698
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 112 16
;; --Quoted Start--
;; --Quoted Start--
        ()
;; --Quoted End--
;; --Quoted End--
        jmp _label_699
;; --If true--
_label_698:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 111 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 111 16
        s"ch"
        @
;; --If Done--
_label_699:
;; --If End--
        swap ret
_label_697:
        proc _label_696
        swap ret
_label_695:
        proc _label_694
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 107 16
        s"?-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 24
        jmp _label_701
_label_700:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"rule"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 23
        jmp _label_703
_label_702:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 32
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 25
        s"rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 118 19
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 22
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 120 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 120 24
        s"ch"
        @
        jnf _label_704
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 21
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 127 20
        s"stream"
        @
        tail_call_in
;; --Call End--
        jmp _label_705
;; --If true--
_label_704:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 125 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 125 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 125 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 125 41
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 125 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 125 38
        s"normalize-chain"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 124 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 124 33
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 124 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 124 26
        s"for-each"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 126 19
        #f
;; --If Done--
_label_705:
;; --If End--
        swap ret
_label_703:
        proc _label_702
        swap ret
_label_701:
        proc _label_700
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 116 18
        s"not-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 138 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 138 13
        jmp _label_707
_label_706:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 135 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 135 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 135 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 135 23
        s"stream"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 135 15
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 138 12
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 136 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 136 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 136 24
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 136 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 136 21
        s"eof-object?"
        @
        call_in
;; --Call End--
        jnf _label_708
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 138 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 138 11
        s"ch"
        @
        jmp _label_709
;; --If true--
_label_708:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 137 11
        #f
;; --If Done--
_label_709:
;; --If End--
        swap ret
_label_707:
        proc _label_706
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 134 18
        s"any-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 34
        jmp _label_711
_label_710:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"ch"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 49
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 23
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 20
        s"char?"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 142 13
        s"not"
        @
        call_in
;; --Call End--
        jnf _label_712
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 49
        ()
        jmp _label_713
;; --If true--
_label_712:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 47
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 47
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 43
        "char-rule requires a char!"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 143 15
        s"error"
        @
        call_in
;; --Call End--
;; --If Done--
_label_713:
;; --If End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 32
        jmp _label_715
_label_714:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream-ch"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 30
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 27
        s"stream-ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 147 17
        s"eq?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_715:
        proc _label_714
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 145 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 145 11
        s"rule"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_711:
        proc _label_710
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 141 19
        s"char-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 59
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 59
        jmp _label_717
_label_716:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 55
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 55
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 51
        s"string->list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 37
        s"char-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 27
        s"map"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 22
        s"chain-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 151 11
        s"apply"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_717:
        proc _label_716
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 150 18
        s"str-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 56
        jmp _label_719
_label_718:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"str"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 52
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 52
        s"str"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 48
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 48
        s"string->list"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 34
        s"char-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 24
        s"map"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 19
        s"or-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 155 11
        s"apply"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_719:
        proc _label_718
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 154 18
        s"set-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 44
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 44
        jmp _label_721
_label_720:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"start"
        bind
        cdr
;; ----
        dup
        car
        s"end"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 42
        jmp _label_723
_label_722:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream-ch"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 41
;; --Bool Operator Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 42
        s"start"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 36
        s"stream-ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 161 26
        s"char>=?"
        @
        call_in
;; --Call End--
        dup
        jnf _label_725
        jmp _label_724
_label_725:
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 39
        s"end"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 35
        s"stream-ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 162 25
        s"char<=?"
        @
        call_in
;; --Call End--
_label_724:
;; --Bool Operator End--
        swap ret
_label_723:
        proc _label_722
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 159 10
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 159 10
        s"rule"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_721:
        proc _label_720
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 158 20
        s"range-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 35
        s"any-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 26
        s"*-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 165 18
        s"rest-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 174 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 174 18
        jmp _label_727
_label_726:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 169 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 169 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 169 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 169 23
        s"stream"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 169 15
        s"ch"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 174 17
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 170 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 170 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 170 24
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 170 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 170 21
        s"eof-object?"
        @
        call_in
;; --Call End--
        jnf _label_728
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 173 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 173 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 173 23
        s"ch"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 173 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 173 20
        s"stream"
        @
        call_in
;; --Call End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 174 15
        #f
        jmp _label_729
;; --If true--
_label_728:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 171 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 171 11
        s"ch"
        @
;; --If Done--
_label_729:
;; --If End--
        swap ret
_label_727:
        proc _label_726
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/matchers.scm" 168 18
        s"eof-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 10 23
;; --Record Start--
;; --Quoted Start--
        ()
;; --Quoted Start--
        ()
        s"token-text"
        cons
        s"text"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"token-type"
        cons
        s"type"
        cons
;; --Quoted End--
        cons
        s"token?"
        cons
;; --Quoted Start--
        ()
        s"text"
        cons
        s"type"
        cons
        s"token"
        cons
;; --Quoted End--
        cons
        s"<token>"
        cons
;; --Quoted End--
        s"record-type-factory"
        @
        call_in
;; --Record Binding--
_label_730:
        dup
        null?
        jnf _label_731
        dup
        car
        dup
        cdr
        swap
        car
        bind
        cdr
        jmp _label_730
_label_731:
;; --Record End--
        drop
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 22 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 22 18
        jmp _label_733
_label_732:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"type"
        bind
        cdr
;; ----
        dup
        car
        s"rule"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 22 17
        jmp _label_735
_label_734:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 35
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 28
        s"rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 15 22
        s"match"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 22 16
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 17 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 17 26
        s"match"
        @
        jnf _label_736
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 22 15
        #f
        jmp _label_737
;; --If true--
_label_736:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 52
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 19 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 19 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 19 39
        s"match"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 19 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 19 33
        s"eof-object?"
        @
        call_in
;; --Call End--
        jnf _label_738
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 49
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 49
        s"match"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 43
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 43
        s"flatten"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 21 34
        s"list->string"
        @
        call_in
;; --Call End--
        jmp _label_739
;; --If true--
_label_738:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 20 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 20 26
        s"match"
        @
;; --If Done--
_label_739:
;; --If End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 18 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 18 24
        s"type"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 18 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 18 19
        s"token"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_737:
;; --If End--
        swap ret
_label_735:
        proc _label_734
        swap ret
_label_733:
        proc _label_732
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 13 20
        s"bind-token"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 45
        jmp _label_741
_label_740:
        swap
;; -- Formals --
;; ----
        s"rule-list"
        bind
;; ----
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 42
        s"any-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 33
;; --Quoted Start--
        s"*UNMATCHED*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 32 20
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 31 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 31 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 31 37
        s"eof-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 31 28
;; --Quoted Start--
        s"*EOF*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 31 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 31 21
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 33
        s"rule-list"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 23
        s"or-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 29 15
        s"apply"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 28 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 28 13
        s"or-rule"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_741:
        proc _label_740
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 27 20
        s"make-lexer"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 43 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 43 12
        jmp _label_743
_label_742:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"lexer"
        bind
        cdr
;; ----
        dup
        car
        s"rule"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 42 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 42 20
        jmp _label_745
_label_744:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 36
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 29
        s"lexer"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 38 22
        s"token"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 42 19
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 40 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 40 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 40 25
        s"token"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 40 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 40 19
        s"rule"
        @
        call_in
;; --Call End--
        jnf _label_746
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 42 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 42 18
        s"token"
        @
        jmp _label_747
;; --If true--
_label_746:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 41 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 41 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 41 27
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 41 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 41 20
        s"filter"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_747:
;; --If End--
        swap ret
_label_745:
        proc _label_744
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 37 20
        s"filter"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 43 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 43 11
        s"filter"
        @
        swap ret
_label_743:
        proc _label_742
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 36 29
        s"filter-token-stream"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 39
        jmp _label_749
_label_748:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"token"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 37
        jmp _label_751
_label_750:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"in-token"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 34
        s"token"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 52 28
        s"token-type"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 51 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 51 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 51 37
        s"in-token"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 51 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 51 28
        s"token-type"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 50 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 50 17
        s"eq?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_751:
        proc _label_750
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 48 10
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 48 10
        s"rule"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_749:
        proc _label_748
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/token.scm" 47 20
        s"token-rule"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 17 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 17 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 17 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 17 25
        #\x09
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 17 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 17 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 16 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 16 25
        #\x20
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 16 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 16 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 15 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 15 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 14 32
        s"<intraline-whitespace>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 28 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 28 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 28 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 28 25
        #\x0D
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 28 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 28 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 27 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 27 25
        #\x0A
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 27 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 27 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 26 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 26 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 26 29
        #\x0A
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 26 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 26 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 25 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 25 29
        #\x0D
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 25 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 25 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 24 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 24 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 23 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 23 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 23 29
        #\x0D
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 23 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 23 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 22 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 22 29
        #\x0A
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 22 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 22 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 21 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 21 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 20 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 20 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 19 23
        s"<line-ending>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 34 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 34 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 34 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 34 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 34 26
        s"<line-ending>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 33 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 33 35
        s"<intraline-whitespace>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 32 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 32 18
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 31 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 31 12
        s"+-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/lexer/core.scm" 30 22
        s"<whitespace>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 11 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 11 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 11 37
        #\(
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 11 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 11 33
        s"char-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 11 22
        s"<open-paren>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 12 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 12 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 12 37
        #\)
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 12 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 12 33
        s"char-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 12 22
        s"<close-paren>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 14 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 14 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 14 40
        #\|
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 14 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 14 36
        s"char-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 14 25
        s"<vertical-line>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 23 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 23 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 23 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 23 23
        #\;
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 23 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 23 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 22 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 22 23
        #\"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 22 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 22 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 21 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 21 23
        #\)
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 21 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 21 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 20 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 20 23
        #\(
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 20 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 20 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 19 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 19 24
        s"<vertical-line>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 18 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 18 21
        s"<whitespace>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 17 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 17 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 16 21
        s"<delimiter>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 28 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 28 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 28 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 28 34
        "#!no-fold-case"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 28 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 28 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 27 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 27 31
        "#!fold-case"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 27 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 27 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 26 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 26 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 25 21
        s"<directive>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 35 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 35 10
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 34 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 34 20
        s"<directive>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 33 45
        jmp _label_753
_label_752:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 33 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 33 43
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 33 43
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 33 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 33 36
        s"<comment>"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_753:
        proc _label_752
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 32 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 32 21
        s"<whitespace>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 31 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 31 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 30 22
        s"<atmosphere>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 38 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 38 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 38 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 38 25
        s"<atmosphere>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 38 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 38 12
        s"*-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 37 28
        s"<intertoken-space>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 43 48
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 43 47
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 43 45
        "#|"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 43 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 43 41
        s"str-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 43 31
        s"<nested-comment-start>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 44 46
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 44 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 44 43
        "|#"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 44 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 44 39
        s"str-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 44 29
        s"<nested-comment-end>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 51 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 51 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 51 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 51 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 51 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 51 37
        s"<nested-comment-end>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 50 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 50 39
        s"<nested-comment-start>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 49 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 49 21
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 48 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 48 18
        s"not-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 47 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 47 12
        s"+-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 46 24
        s"<comment-text>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 64 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 64 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 64 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 64 29
        s"<nested-comment-end>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 63 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 63 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 63 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 63 31
        s"<comment-text>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 62 60
        jmp _label_755
_label_754:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 62 59
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 62 58
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 62 58
        s"stream"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 62 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 62 51
        s"<nested-comment>"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_755:
        proc _label_754
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 60 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 60 22
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 59 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 59 16
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 55 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 55 31
        s"<nested-comment-start>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 54 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 54 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 53 26
        s"<nested-comment>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 80 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 80 10
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 79 14
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 77 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 77 31
        s"<intertoken-space>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 76 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 76 26
        "#;"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 76 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 76 22
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 75 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 75 21
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 73 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 73 25
        s"<nested-comment>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 40
        s"<line-ending>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 72 26
        s"not-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 71 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 71 20
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 70 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 70 27
        #\;
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 70 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 70 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 69 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 69 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 67 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 67 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 66 19
        s"<comment>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 28
        #\z
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 24
        #\a
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 90 20
        s"range-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 89 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 89 28
        #\Z
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 89 24
        #\A
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 89 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 89 20
        s"range-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 88 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 88 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 87 17
        s"<letter>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 92 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 92 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 92 39
        "+-"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 92 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 92 35
        s"set-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 92 25
        s"<explicit-sign>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 37
        #\9
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 33
        #\0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 29
        s"range-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 94 17
        s"<digit>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 100 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 100 17
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 100 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 100 16
        s"<digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 99 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 99 28
        #\F
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 99 24
        #\A
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 99 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 99 20
        s"range-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 98 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 98 28
        #\f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 98 24
        #\a
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 98 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 98 20
        s"range-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 97 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 97 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 96 21
        s"<hex-digit>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 50
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 48
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 48
        s"<hex-digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 36
        s"+-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 102 28
        s"<hex-scalar-value>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 107 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 107 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 107 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 107 27
        s"<hex-scalar-value>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 106 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 106 22
        "\x"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 106 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 106 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 105 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 105 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 104 29
        s"<inline-hex-escape>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 112 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 112 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 112 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 112 25
        "abtnr"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 112 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 112 18
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 111 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 111 23
        #\\
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 111 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 111 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 110 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 110 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 109 27
        s"<mnemomic-escape>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 119 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 119 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 119 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 119 22
        "\|"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 119 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 119 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 118 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 118 26
        s"<mnemomic-escape>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 117 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 117 28
        s"<inline-hex-escape>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 33
        "\\|"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 28
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 116 18
        s"not-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 115 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 115 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 114 26
        s"<symbol-element>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 121 57
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 121 56
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 121 54
        "!$%&*/:<=>?@^_~"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 121 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 121 37
        s"set-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 121 27
        s"<special-initial>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 126 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 126 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 126 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 126 26
        s"<special-initial>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 125 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 125 17
        s"<letter>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 124 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 124 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 123 19
        s"<initial>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 131 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 131 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 131 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 131 24
        s"<explicit-sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 130 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 130 22
        ".@"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 130 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 130 18
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 129 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 129 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 128 38
        s"<special-subsequent>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 137 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 137 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 137 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 137 29
        s"<special-subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 136 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 136 16
        s"<digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 135 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 135 18
        s"<initial>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 134 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 134 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 133 22
        s"<subsequent>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 143 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 143 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 143 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 143 23
        #\@
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 143 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 143 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 142 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 142 24
        s"<explicit-sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 141 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 141 18
        s"<initial>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 140 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 140 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 139 27
        s"<sign-subsequent>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 145 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 145 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 145 30
        #\.
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 145 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 145 26
        s"char-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 145 15
        s"<dot>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 150 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 150 15
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 150 14
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 150 14
        s"<dot>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 149 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 149 26
        s"<sign-subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 148 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 148 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 147 26
        s"<dot-subsequent>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 33
        s"<subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 170 20
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 169 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 169 29
        s"<dot-subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 168 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 168 18
        s"<dot>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 167 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 167 29
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 165 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 165 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 165 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 165 33
        s"<subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 165 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 165 20
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 164 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 164 29
        s"<dot-subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 163 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 163 18
        s"<dot>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 162 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 162 28
        s"<explicit-sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 161 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 161 29
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 159 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 159 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 159 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 159 33
        s"<subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 159 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 159 20
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 158 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 158 30
        s"<sign-subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 157 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 157 28
        s"<explicit-sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 156 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 156 21
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 154 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 154 24
        s"<explicit-sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 153 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 153 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 152 31
        s"<peculiar-identifier>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 182 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 182 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 182 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 182 31
        s"<peculiar-identifier>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 180 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 180 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 180 28
        s"<vertical-line>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 179 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 179 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 179 37
        s"<symbol-element>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 179 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 179 20
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 178 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 178 28
        s"<vertical-line>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 177 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 177 21
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 43
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 43
        s"<subsequent>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 30
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 175 22
        s"<initial>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 174 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 174 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 173 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 173 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 172 22
        s"<identifier>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 191 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 191 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 191 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 191 25
        "#true"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 191 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 191 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 190 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 190 22
        "#t"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 190 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 190 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 189 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 189 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 188 24
        s"<boolean-true>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 196 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 196 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 196 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 196 26
        "#false"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 196 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 196 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 195 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 195 22
        "#f"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 195 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 195 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 194 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 194 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 193 25
        s"<boolean-false>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 212 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 212 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 212 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 212 23
        "tab"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 212 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 212 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 211 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 211 25
        "space"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 211 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 211 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 210 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 210 26
        "return"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 210 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 210 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 209 26
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 209 24
        "null"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 209 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 209 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 208 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 208 27
        "newline"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 208 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 208 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 207 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 207 26
        "escape"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 207 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 207 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 206 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 206 26
        "delete"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 206 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 206 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 205 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 205 29
        "backspace"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 205 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 205 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 204 27
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 204 25
        "alarm"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 204 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 204 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 203 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 203 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 202 26
        s"<character-name>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 225 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 225 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 225 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 225 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 225 22
        s"any-rule"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 223 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 223 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 223 35
        s"<hex-scalar-value>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 222 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 222 31
        #\x
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 222 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 222 27
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 221 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 221 25
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 219 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 219 29
        s"<character-name>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 218 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 218 17
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 217 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 217 23
        #\\
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 217 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 217 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 216 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 216 23
        #\#
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 216 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 216 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 215 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 215 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 214 21
        s"<character>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 31
        #\\
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 251 27
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 250 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 250 31
        #\"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 250 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 250 27
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 249 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 249 21
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 248 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 248 19
        s"not-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 51
        s"<intraline-whitespace>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 246 28
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 245 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 245 34
        s"<line-ending>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 244 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 244 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 244 51
        s"<intraline-whitespace>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 244 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 244 28
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 243 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 243 28
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 242 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 242 31
        #\|
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 242 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 242 27
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 241 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 241 31
        #\\
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 241 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 241 27
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 240 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 240 31
        #\"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 240 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 240 27
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 239 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 239 21
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 238 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 238 27
        #\\
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 238 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 238 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 237 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 237 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 234 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 234 26
        s"<mnemomic-escape>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 233 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 233 28
        s"<inline-hex-escape>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 232 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 232 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 231 26
        s"<string-element>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 257 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 257 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 257 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 257 23
        #\"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 257 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 257 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 256 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 256 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 256 33
        s"<string-element>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 256 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 256 16
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 255 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 255 23
        #\"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 255 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 255 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 254 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 254 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 253 18
        s"<string>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 264 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 264 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 264 36
        "+-"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 264 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 264 32
        s"set-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 264 22
        s"<plus-minus>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 37
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 36
        s"<plus-minus>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 23
        s"?-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 265 15
        s"<sign>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 267 44
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 267 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 267 41
        "eE"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 267 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 267 37
        s"set-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 267 27
        s"<exponent-marker>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 31
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 28
        "iIeE"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 272 22
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 271 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 271 27
        #\#
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 271 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 271 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 270 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 270 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 269 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 269 12
        s"?-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 268 20
        s"<exactness>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 277 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 277 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 277 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 277 22
        "bB"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 277 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 277 18
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 276 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 276 23
        #\#
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 276 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 276 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 275 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 275 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 274 19
        s"<radix-2>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 282 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 282 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 282 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 282 22
        "oO"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 282 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 282 18
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 281 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 281 23
        #\#
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 281 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 281 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 280 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 280 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 279 27
        s"<radix-8>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 26
        "dD"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 288 22
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 287 28
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 287 27
        #\#
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 287 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 287 23
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 286 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 286 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 285 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 285 12
        s"?-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 284 20
        s"<radix-10>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 293 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 293 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 293 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 293 22
        "xX"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 293 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 293 18
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 292 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 292 23
        #\#
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 292 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 292 19
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 291 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 291 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 290 20
        s"<radix-16>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 295 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 295 35
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 295 33
        "01"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 295 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 295 29
        s"set-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 295 19
        s"<digit-2>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 39
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 38
        #\7
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 34
        #\0
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 30
        s"range-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 296 18
        s"<digit-8>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 297 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 297 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 297 27
        s"<digit>"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 297 19
        s"<digit-10>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 298 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 298 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 298 31
        s"<hex-digit>"
        @
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 298 19
        s"<digit-16>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 31
        s"<digit-10>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 305 20
        s"+-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 304 19
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 304 19
        s"<sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 303 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 303 30
        s"<exponent-marker>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 302 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 302 20
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 301 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 301 12
        s"?-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 300 18
        s"<suffix>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 319 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 319 25
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 319 24
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 319 22
        ".0"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 319 18
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 319 18
        s"str-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 318 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 318 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 318 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 318 30
        "nN"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 318 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 318 26
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 317 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 317 30
        "aA"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 317 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 317 26
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 316 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 316 30
        "nN"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 316 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 316 26
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 315 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 315 24
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 314 33
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 314 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 314 30
        "fF"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 314 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 314 26
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 313 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 313 30
        "nN"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 313 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 313 26
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 312 32
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 312 30
        "iI"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 312 26
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 312 26
        s"set-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 311 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 311 24
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 310 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 310 17
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 309 15
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 309 15
        s"<sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 308 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 308 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 307 18
        s"<infnan>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 321 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 321 29
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 321 27
        "iI"
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 321 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 321 23
        s"set-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 321 13
        s"<i>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 34
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 33
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 33
        s"<i>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 29
        s"<plus-minus>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 324 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 323 24
        s"<plus-minus-i>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 29
        s"<i>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 25
        s"<infnan>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 16
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 327 16
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 326 26
        s"<complex-infnan>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 378 12
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 378 12
        jmp _label_757
_label_756:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"has-decimal"
        bind
        cdr
;; ----
        dup
        car
        s"digit>"
        bind
        cdr
;; ----
        dup
        car
        s"<radix>"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 38
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 37
        s"<exactness>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 25
        s"<radix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 332 17
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 331 30
        s"<radix-exactness>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 58
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 56
        s"<radix-exactness>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 38
        s"<radix-exactness>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 335 20
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 334 22
        s"<prefix>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 41
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 40
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 40
        s"<digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 32
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 32
        s"+-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 337 24
        s"<uinteger>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 347 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 347 34
;; --If Start--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 340 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 340 24
        s"has-decimal"
        @
        jnf _label_758
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 347 33
        jmp _label_761
_label_760:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 347 32
        #f
        swap ret
_label_761:
        proc _label_760
        jmp _label_759
;; --If true--
_label_758:
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 79
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 78
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 77
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 77
        s"<suffix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 68
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 67
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 67
        s"<digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 59
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 59
        s"*-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 51
        s"<dot>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 44
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 44
        s"<digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 36
        s"+-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 344 28
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 61
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 60
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 60
        s"<suffix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 50
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 50
        s"<digit>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 42
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 42
        s"+-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 34
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 34
        s"<dot>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 343 28
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 49
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 48
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 48
        s"<suffix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 39
        s"<uinteger>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 28
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 342 28
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 341 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 341 21
        s"or-rule"
        @
        call_in
;; --Call End--
;; --If Done--
_label_759:
;; --If End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 339 26
        s"<decimal>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 353 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 353 23
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 353 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 353 22
        s"<decimal>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 352 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 352 23
        s"<uinteger>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 63
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 62
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 62
        s"<uinteger>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 50
        #\/
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 46
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 46
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 35
        s"<uinteger>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 351 24
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 350 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 350 17
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 349 22
        s"<ureal>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 358 23
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 358 22
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 358 21
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 358 21
        s"<infnan>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 39
        s"<ureal>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 31
        s"<sign>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 357 24
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 356 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 356 17
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 355 20
        s"<real>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 364 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 364 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 364 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 364 29
        s"<complex-infnan>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 363 27
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 363 27
        s"<plus-minus-i>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 50
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 49
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 49
        s"<i>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 45
        s"<ureal>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 37
        s"<plus-minus>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 362 24
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 361 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 361 17
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 360 30
        s"<complex-suffix>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 373 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 373 30
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 373 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 373 29
        s"<complex-suffix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 372 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 372 43
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 372 42
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 372 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 372 41
        s"<complex-suffix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 60
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 59
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 59
        s"<real>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 51
        #\@
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 47
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 47
        s"char-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 36
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 371 36
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 370 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 370 29
        s"or-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 369 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 369 24
        s"?-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 368 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 368 31
        s"<real>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 368 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 368 24
        s"chain-rule"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 367 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 367 17
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 366 25
        s"<complex>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 41
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 40
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 39
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 39
        s"<complex>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 29
        s"<prefix>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 376 20
        s"chain-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 375 19
        s"<num>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 378 11
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 378 11
        s"<num>"
        @
        swap ret
_label_757:
        proc _label_756
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 330 22
        s"make-numbers"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 54
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 54
        s"<radix-2>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 44
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 44
        s"<digit-2>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 34
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 31
        s"make-numbers"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 380 17
        s"<num-2>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 55
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 53
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 53
        s"<radix-8>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 43
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 43
        s"<digit-8>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 33
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 30
        s"make-numbers"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 381 16
        s"<num-8>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 58
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 56
        s"<radix-10>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 45
        s"<digit-10>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 34
        #t
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 31
        s"make-numbers"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 382 17
        s"<num-10>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 58
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 56
        s"<radix-16>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 45
        s"<digit-16>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 34
        #f
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 31
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 31
        s"make-numbers"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 383 17
        s"<num-16>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 49
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 48
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 47
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 47
        s"<num-16>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 38
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 38
        s"<num-8>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 30
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 30
        s"<num-2>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 22
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 22
        s"<num-10>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 13
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 386 13
        s"or-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 385 18
        s"<number>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 391 46
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 391 45
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 391 43
        "#u8("
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 391 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 391 37
        s"str-rule"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 391 27
        s"<bytevector-start>"
        bind
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 55
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 53
        jmp _label_763
_label_762:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"token"
        bind
;; ----
        drop
;; -- Body --
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 51
;; --Quoted Start--
        s"*white-space*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 36
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 35
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 35
        s"token"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 29
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 29
        s"token-type"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 17
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 417 17
        s"eq?"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_763:
        proc _label_762
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 55
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 53
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 53
        s"<whitespace>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 40
;; --Quoted Start--
        s"*white-space*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 414 25
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 412 44
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 412 43
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 412 43
        s"<string>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 412 34
;; --Quoted Start--
        s"*string*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 412 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 412 24
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 411 51
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 411 50
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 411 50
        s"<character>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 411 38
;; --Quoted Start--
        s"*character*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 411 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 411 25
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 409 65
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 409 64
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 409 64
        s"<bytevector-start>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 409 45
;; --Quoted Start--
        s"*bytevector-start*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 409 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 409 25
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 407 54
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 407 53
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 407 53
        s"<close-paren>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 407 39
;; --Quoted Start--
        s"*close-paren*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 407 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 407 24
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 406 53
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 406 52
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 406 52
        s"<open-paren>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 406 39
;; --Quoted Start--
        s"*open-paren*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 406 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 406 25
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 404 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 404 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 404 56
        s"<number>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 404 47
;; --Quoted Start--
        s"*number*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 404 37
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 404 37
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 402 58
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 402 57
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 402 57
        s"<boolean-false>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 402 41
;; --Quoted Start--
        s"*boolean-false*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 402 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 402 24
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 401 57
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 401 56
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 401 56
        s"<boolean-true>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 401 41
;; --Quoted Start--
        s"*boolean-true*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 401 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 401 25
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 399 52
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 399 51
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 399 51
        s"<identifier>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 399 38
;; --Quoted Start--
        s"*identifier*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 399 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 399 24
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 398 46
;; --Call Start--
        ()
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 398 45
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 398 45
        s"<comment>"
        @
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 398 35
;; --Quoted Start--
        s"*comment*"
;; --Quoted End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 398 24
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 398 24
        s"bind-token"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 397 20
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 397 20
        s"make-lexer"
        @
        call_in
;; --Call End--
        cons
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 396 25
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 396 25
        s"filter-token-stream"
        @
        call_in
;; --Call End--
.file "/Users/jules/code/scheme_projects/insomniac/src/core/scheme/lexer.scm" 395 21
        s"scheme-lexer"
        bind
.file "./src/core/insomniac-core.scm" 13 57
;; --Record Start--
;; --Quoted Start--
        ()
;; --Quoted Start--
        ()
        s"insc-config-output-set!"
        cons
        s"insc-config-output"
        cons
        s"output"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"insc-config-source-set!"
        cons
        s"insc-config-source"
        cons
        s"source"
        cons
;; --Quoted End--
        cons
;; --Quoted Start--
        ()
        s"insc-config-name"
        cons
        s"name"
        cons
;; --Quoted End--
        cons
        s"insc-config?"
        cons
;; --Quoted Start--
        ()
        s"output"
        cons
        s"source"
        cons
        s"name"
        cons
        s"make-insc-config"
        cons
;; --Quoted End--
        cons
        s":insc-config"
        cons
;; --Quoted End--
        s"record-type-factory"
        @
        call_in
;; --Record Binding--
_label_764:
        dup
        null?
        jnf _label_765
        dup
        car
        dup
        cdr
        swap
        car
        bind
        cdr
        jmp _label_764
_label_765:
;; --Record End--
        drop
.file "./src/core/insomniac-core.scm" 38 36
.file "./src/core/insomniac-core.scm" 38 36
        jmp _label_767
_label_766:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"cmd-line"
        bind
;; ----
        drop
;; -- Body --
.file "./src/core/insomniac-core.scm" 38 35
;; -- Let* --
        ()
        proc _label_768
        tail_call_in
_label_768:
        swap drop
;; -- Binding List--
.file "./src/core/insomniac-core.scm" 19 31
.file "./src/core/insomniac-core.scm" 19 30
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 19 29
.file "./src/core/insomniac-core.scm" 19 29
        s"cmd-line"
        @
        cons
.file "./src/core/insomniac-core.scm" 19 20
.file "./src/core/insomniac-core.scm" 19 20
        s"car"
        @
        call_in
;; --Call End--
.file "./src/core/insomniac-core.scm" 19 15
        s"name"
        bind
.file "./src/core/insomniac-core.scm" 20 31
.file "./src/core/insomniac-core.scm" 20 30
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 20 29
.file "./src/core/insomniac-core.scm" 20 29
        s"cmd-line"
        @
        cons
.file "./src/core/insomniac-core.scm" 20 20
.file "./src/core/insomniac-core.scm" 20 20
        s"cdr"
        @
        call_in
;; --Call End--
.file "./src/core/insomniac-core.scm" 20 15
        s"args"
        bind
.file "./src/core/insomniac-core.scm" 21 53
.file "./src/core/insomniac-core.scm" 21 52
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 21 50
        "a.out"
        cons
.file "./src/core/insomniac-core.scm" 21 43
        ""
        cons
.file "./src/core/insomniac-core.scm" 21 40
.file "./src/core/insomniac-core.scm" 21 40
        s"name"
        @
        cons
.file "./src/core/insomniac-core.scm" 21 35
.file "./src/core/insomniac-core.scm" 21 35
        s"make-insc-config"
        @
        call_in
;; --Call End--
.file "./src/core/insomniac-core.scm" 21 17
        s"config"
        bind
.file "./src/core/insomniac-core.scm" 25 23
.file "./src/core/insomniac-core.scm" 25 22
        jmp _label_771
_label_770:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "./src/core/insomniac-core.scm" 23 27
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 23 26
.file "./src/core/insomniac-core.scm" 23 26
        s"name"
        @
        cons
.file "./src/core/insomniac-core.scm" 23 21
.file "./src/core/insomniac-core.scm" 23 21
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 24 34
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 24 32
        " <source>"
        cons
.file "./src/core/insomniac-core.scm" 24 21
.file "./src/core/insomniac-core.scm" 24 21
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 25 21
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 25 20
        1
        cons
.file "./src/core/insomniac-core.scm" 25 18
.file "./src/core/insomniac-core.scm" 25 18
        s"exit"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_771:
        proc _label_770
.file "./src/core/insomniac-core.scm" 22 16
        s"usage"
        bind
.file "./src/core/insomniac-core.scm" 33 42
.file "./src/core/insomniac-core.scm" 33 41
        jmp _label_773
_label_772:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"config"
        bind
        cdr
;; ----
        dup
        car
        s"cmd-line"
        bind
;; ----
        drop
;; -- Body --
.file "./src/core/insomniac-core.scm" 33 40
;; --Cond Start--
;; ----Cond Clause----
.file "./src/core/insomniac-core.scm" 29 42
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 29 41
.file "./src/core/insomniac-core.scm" 29 41
        s"cmd-line"
        @
        cons
.file "./src/core/insomniac-core.scm" 29 32
.file "./src/core/insomniac-core.scm" 29 32
        s"null?"
        @
        call_in
;; --Call End--
        not
        jnf _label_775
.file "./src/core/insomniac-core.scm" 29 49
.file "./src/core/insomniac-core.scm" 29 49
        s"config"
        @
        jmp _label_774
_label_775:
;; ----Cond Clause----
.file "./src/core/insomniac-core.scm" 30 55
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 30 54
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 30 53
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 30 52
.file "./src/core/insomniac-core.scm" 30 52
        s"cmd-line"
        @
        cons
.file "./src/core/insomniac-core.scm" 30 43
.file "./src/core/insomniac-core.scm" 30 43
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 30 38
        ""
        cons
.file "./src/core/insomniac-core.scm" 30 35
.file "./src/core/insomniac-core.scm" 30 35
        s"eq?"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 30 30
.file "./src/core/insomniac-core.scm" 30 30
        s"not"
        @
        call_in
;; --Call End--
        not
        jnf _label_776
.file "./src/core/insomniac-core.scm" 31 76
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 31 75
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 31 74
.file "./src/core/insomniac-core.scm" 31 74
        s"cmd-line"
        @
        cons
.file "./src/core/insomniac-core.scm" 31 65
.file "./src/core/insomniac-core.scm" 31 65
        s"car"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 31 60
.file "./src/core/insomniac-core.scm" 31 60
        s"config"
        @
        cons
.file "./src/core/insomniac-core.scm" 31 53
.file "./src/core/insomniac-core.scm" 31 53
        s"insc-config-source-set!"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 32 59
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 32 58
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 32 57
.file "./src/core/insomniac-core.scm" 32 57
        s"cmd-line"
        @
        cons
.file "./src/core/insomniac-core.scm" 32 48
.file "./src/core/insomniac-core.scm" 32 48
        s"cdr"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 32 43
.file "./src/core/insomniac-core.scm" 32 43
        s"config"
        @
        cons
.file "./src/core/insomniac-core.scm" 32 36
.file "./src/core/insomniac-core.scm" 32 36
        s"walker"
        @
        tail_call_in
;; --Call End--
        jmp _label_774
_label_776:
;; ----Cond Clause----
.file "./src/core/insomniac-core.scm" 33 30
.file "./src/core/insomniac-core.scm" 33 30
        s"else"
        @
        not
        jnf _label_777
.file "./src/core/insomniac-core.scm" 33 38
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 33 37
.file "./src/core/insomniac-core.scm" 33 37
        s"usage"
        @
        tail_call_in
;; --Call End--
        jmp _label_774
_label_777:
;; --Cond Fall-Through--
        ()
_label_774:
;; --Cond End--
        swap ret
_label_773:
        proc _label_772
.file "./src/core/insomniac-core.scm" 27 18
        s"walker"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "./src/core/insomniac-core.scm" 38 34
;; --If Start--
.file "./src/core/insomniac-core.scm" 36 36
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 36 35
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 36 34
.file "./src/core/insomniac-core.scm" 36 34
        s"args"
        @
        cons
.file "./src/core/insomniac-core.scm" 36 29
.file "./src/core/insomniac-core.scm" 36 29
        s"length"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 36 21
        0
        cons
.file "./src/core/insomniac-core.scm" 36 19
.file "./src/core/insomniac-core.scm" 36 19
        s"eq?"
        @
        call_in
;; --Call End--
        jnf _label_778
.file "./src/core/insomniac-core.scm" 38 33
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 38 32
.file "./src/core/insomniac-core.scm" 38 32
        s"args"
        @
        cons
.file "./src/core/insomniac-core.scm" 38 27
.file "./src/core/insomniac-core.scm" 38 27
        s"config"
        @
        cons
.file "./src/core/insomniac-core.scm" 38 20
.file "./src/core/insomniac-core.scm" 38 20
        s"walker"
        @
        tail_call_in
;; --Call End--
        jmp _label_779
;; --If true--
_label_778:
.file "./src/core/insomniac-core.scm" 37 20
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 37 19
.file "./src/core/insomniac-core.scm" 37 19
        s"usage"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_779:
;; --If End--
;; -- Let* Body End--
        swap ret
_label_769:
;; -- Let* End --
        swap ret
_label_767:
        proc _label_766
.file "./src/core/insomniac-core.scm" 17 22
        s"build-config"
        bind
.file "./src/core/insomniac-core.scm" 46 38
.file "./src/core/insomniac-core.scm" 46 38
        jmp _label_781
_label_780:
        swap
;; -- Formals --
;; ----
        dup
        car
        s"lexer"
        bind
        cdr
;; ----
        dup
        car
        s"stream"
        bind
;; ----
        drop
;; -- Body --
.file "./src/core/insomniac-core.scm" 41 34
.file "./src/core/insomniac-core.scm" 41 33
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 41 32
.file "./src/core/insomniac-core.scm" 41 32
        s"stream"
        @
        cons
.file "./src/core/insomniac-core.scm" 41 25
.file "./src/core/insomniac-core.scm" 41 25
        s"lexer"
        @
        call_in
;; --Call End--
.file "./src/core/insomniac-core.scm" 41 18
        s"token"
        bind
.file "./src/core/insomniac-core.scm" 43 21
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 43 20
.file "./src/core/insomniac-core.scm" 43 20
        s"token"
        @
        cons
.file "./src/core/insomniac-core.scm" 43 14
.file "./src/core/insomniac-core.scm" 43 14
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 43 31
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 43 30
.file "./src/core/insomniac-core.scm" 43 30
        s"newline"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 46 37
;; --If Start--
.file "./src/core/insomniac-core.scm" 45 47
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 45 46
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 45 45
;; --Quoted Start--
        s"*EOF*"
;; --Quoted End--
        cons
.file "./src/core/insomniac-core.scm" 45 38
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 45 37
.file "./src/core/insomniac-core.scm" 45 37
        s"token"
        @
        cons
.file "./src/core/insomniac-core.scm" 45 31
.file "./src/core/insomniac-core.scm" 45 31
        s"token-type"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 45 19
.file "./src/core/insomniac-core.scm" 45 19
        s"eq?"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 45 14
.file "./src/core/insomniac-core.scm" 45 14
        s"not"
        @
        call_in
;; --Call End--
        jnf _label_782
.file "./src/core/insomniac-core.scm" 46 37
        ()
        jmp _label_783
;; --If true--
_label_782:
.file "./src/core/insomniac-core.scm" 46 36
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 46 35
.file "./src/core/insomniac-core.scm" 46 35
        s"stream"
        @
        cons
.file "./src/core/insomniac-core.scm" 46 28
.file "./src/core/insomniac-core.scm" 46 28
        s"lexer"
        @
        cons
.file "./src/core/insomniac-core.scm" 46 22
.file "./src/core/insomniac-core.scm" 46 22
        s"token-walker"
        @
        tail_call_in
;; --Call End--
;; --If Done--
_label_783:
;; --If End--
        swap ret
_label_781:
        proc _label_780
.file "./src/core/insomniac-core.scm" 40 23
        s"token-walker"
        bind
.file "./src/core/insomniac-core.scm" 60 53
;; -- Let* --
        call _label_784
        jmp _label_785
_label_784:
;; -- Binding List--
.file "./src/core/insomniac-core.scm" 50 44
.file "./src/core/insomniac-core.scm" 50 43
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 50 42
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 50 41
.file "./src/core/insomniac-core.scm" 50 41
        s"command-line"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 50 27
.file "./src/core/insomniac-core.scm" 50 27
        s"build-config"
        @
        call_in
;; --Call End--
.file "./src/core/insomniac-core.scm" 50 13
        s"config"
        bind
        ()
        drop
;; -- Binding List End--
;; -- Let* Body--
.file "./src/core/insomniac-core.scm" 52 33
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 52 31
        "Compiling: "
        cons
.file "./src/core/insomniac-core.scm" 52 18
.file "./src/core/insomniac-core.scm" 52 18
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 53 42
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 53 41
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 53 40
.file "./src/core/insomniac-core.scm" 53 40
        s"config"
        @
        cons
.file "./src/core/insomniac-core.scm" 53 33
.file "./src/core/insomniac-core.scm" 53 33
        s"insc-config-source"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 53 13
.file "./src/core/insomniac-core.scm" 53 13
        s"display"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 54 14
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 54 13
.file "./src/core/insomniac-core.scm" 54 13
        s"newline"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 60 52
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 60 51
        jmp _label_787
_label_786:
        swap
;; -- Formals --
;; ----
        drop
;; -- Body --
.file "./src/core/insomniac-core.scm" 60 50
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 60 49
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 60 48
        4096
        cons
.file "./src/core/insomniac-core.scm" 60 43
.file "./src/core/insomniac-core.scm" 60 43
        s"char-stream"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 60 30
.file "./src/core/insomniac-core.scm" 60 30
        s"scheme-lexer"
        @
        cons
.file "./src/core/insomniac-core.scm" 59 26
.file "./src/core/insomniac-core.scm" 59 26
        s"token-walker"
        @
        tail_call_in
;; --Call End--
        swap ret
_label_787:
        proc _label_786
        cons
.file "./src/core/insomniac-core.scm" 57 36
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 57 35
.file "./src/core/insomniac-core.scm" 57 35
        s"config"
        @
        cons
.file "./src/core/insomniac-core.scm" 57 28
.file "./src/core/insomniac-core.scm" 57 28
        s"insc-config-source"
        @
        call_in
;; --Call End--
        cons
.file "./src/core/insomniac-core.scm" 56 27
.file "./src/core/insomniac-core.scm" 56 27
        s"with-input-from-file"
        @
        call_in
;; --Call End--
;; -- Let* Body End--
        swap ret
_label_785:
;; -- Let* End --
        drop
.file "./src/core/insomniac-core.scm" 62 12
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 62 11
.file "./src/core/insomniac-core.scm" 62 11
        s"gc-stats"
        @
        call_in
;; --Call End--
        drop
.file "./src/core/insomniac-core.scm" 63 10
;; --Call Start--
        ()
.file "./src/core/insomniac-core.scm" 63 9
.file "./src/core/insomniac-core.scm" 63 9
        s"newline"
        @
        call_in
;; --Call End--

;;; Postamble code
;;; This is what actually causes user code to run.
;;; expects ( user-code -- )

        #\newline out
        #\newline out
        "-----------------------------------" out
        #\newline out

        "Returned: " out
        out
        #\newline out

        call stack_dump

        ;; Exit cleanly
        jmp exit

        ;; In the event of an error, dump the stack
panic:
        #\newline dup out out
        "Something has gone wrong!" out
        #\newline dup out out

        call stack_dump
        jmp exit

        ;; Output everything in the stack but the
        ;; return address
stack_dump:
        "Dumping Stack"
        out
        #\newline
        out

        () s"stack-save" bind

stack_dump_loop:
        depth
        1 -
        0 =                     ; Depth + return makes 2
        jnf stack_dump_exit

        swap                    ; Save return context

        ; save stack
        dup s"stack-save" @ swap cons s"stack-save" !

        out
        #\newline
        out

        jmp stack_dump_loop

stack_dump_exit:
        #\newline
        out
        "Empty"
        out
        #\newline
        out

        ; restore stack
        s"stack-save" @

stack_dump_restore:
        dup null?
        jnf stack_dump_done

        dup car ;; push the next stack value back onto the stack

        rot ;; push the restored value to blow the list and return

        cdr ;; move to the next saved stack entry

        jmp stack_dump_restore

stack_dump_done:
        drop ;; drop the empty list

        ret

exit:
