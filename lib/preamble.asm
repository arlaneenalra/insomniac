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

;; Import a dll and return a handle and bindings
;; param list: ( <path-to-dll> )
;; return: ( bindings . library )
scheme-import:
        swap
        car
        import ;; ( library  bindings -- )
        
        cons
        swap ret

;; Call a function from an external dll
;; param list: (library func argument ... )
;; return: any
scheme-call-ext:
        swap
       
        dup 
        ;; get arguments
        cdr cdr

        swap dup

        ;; get library
        car

        swap dup

        ;; get function
        cdr car
        
        ;; call the function
        call_ext
                
        swap ret

user-entry:
        drop ;; drop return address, we won't need it

        s"initial-environment" bind ;; bind the initial environment
        proc env s"bootstrap-environment" bind ;; the current env

        proc scheme-depth s"depth" bind
        proc scheme-gc-stats s"gc-stats" bind
        proc scheme-import s"import" bind
        proc scheme-call-ext s"call-ext" bind

_main:

