;;;
;;; Code generation primitives.
;;;

;; A convenience function to handle looking up from an indexed list of registers
(define (abi-register-builder ret abi-registers)
    (lambda (idx)
        (if (eq? idx '*ret*)
            ret
            (vector-ref abi-registers idx))))


;; Returns a pair of lambdas that help managing list of literal constants
(define (literal-constant-builders directive)
    (define *list* '())

    (define (write-labeled-list)
        (define (walker list)
            (if (null? list)
                #t
                (let*
                    ((entry (car list))
                     (label (cdr entry))
                     (str (car entry)))
                   
                    (write-string label)
                    (write-string ": ")

                    (write-directive directive str)
                    (walker (cdr list)))))
        (walker *list*))

    (define (label-finder target str)
       (define label (assq str *list*))

        (if (not label)
            (begin
                (set! label ((target-labeler target)))
                (set! *list*
                    (cons
                        (cons str label)
                        *list*))
                label)
            (cdr label)))
 

    (cons label-finder  write-labeled-list))

;; Record to store configuration info about a target
(define-record-type <target>
    (target preamble postamble labeler abi-register scratch-register)
    target?
    (preamble target-preamble)
    (postamble target-postamble)
    (labeler target-labeler)
    (abi-register target-abi-register)
    (scratch-register target-scratch-register))

(include "emitter.scm")

(include "mac-arm64.scm")


;; Emit code for the given target defined by the given token stream.
(define (assemble target token-stream)
    ;; Output the preamble
    ((target-preamble target))

    (define (emit-asm)
        (define token (token-stream))
        (define type (token-type token))

        (if (eq? type '*EOF*)
            #t
            (begin
                (cond
                    ;; Literals
                    ((eq? type '*fixnum-literal*)  (emit-fixnum target token))
                    ((eq? type '*string-literal*)  (emit-string target token))
                    ((eq? type '*char-literal*)    (emit-char target token))
                    ((eq? type '*symbol-literal*)  (emit-symbol target token))
                    ((eq? type '*true-literal*)    (emit-op 4))
                    ((eq? type '*false-literal*)   (emit-op 5))
                    ((eq? type '*empty-literal*)   (emit-op 1))
                    ((eq? type '*nop*)             (emit-op 0))

                    ;; Symbol
                    ((eq? type '*make-symbol*)     (emit-op 8))

                    ;; List/pair
                    ((eq? type '*cons*)            (emit-op 9))
                    ((eq? type '*car*)             (emit-op 10))
                    ((eq? type '*cdr*)             (emit-op 11))
                    ((eq? type '*set-car*)         (emit-op 12))
                    ((eq? type '*set-cdr*)         (emit-op 13))

                    ;; Vectors/records
                    ((eq? type '*make-vector*)     (emit-op 14))
                    ((eq? type '*make-byte-vector*)(emit-op 15))
                    ((eq? type '*make-record*)     (emit-op 16))
                    ((eq? type '*index-set*)       (emit-op 17))
                    ((eq? type '*index-ref*)       (emit-op 18))
                    ((eq? type '*vector-length*)   (emit-op 19))
                    ((eq? type '*string-byte-vector*) (emit-op 20))
                    ((eq? type '*byte-vector-string*) (emit-op 21))
                    ((eq? type '*int-to-char*)     (emit-op 22))
                    ((eq? type '*char-to-int*)     (emit-op 23))

                    ;; Control flow (with jump targets)
                    ((eq? type '*call*)            (emit-call target token))
                    ((eq? type '*adopt*)           (emit-op 25))
                    ((eq? type '*proc*)            (emit-proc target token))
                    ((eq? type '*jmp*)             (emit-jmp target token))
                    ((eq? type '*jnf*)             (emit-jnf target token))
                    ((eq? type '*ret*)             (emit-op 29))
                    ((eq? type '*jin*)             (emit-op 30))
                    ((eq? type '*call-in*)         (emit-op 31))
                    ((eq? type '*tail-call-in*)    (emit-op 32))
                    ((eq? type '*continue*)        (emit-continue target token))

                    ;; Exceptions
                    ((eq? type '*restore*)         (emit-op 34))
                    ((eq? type '*throw*)           (emit-op 35))

                    ;; Variable binding
                    ((eq? type '*bind*)            (emit-op 36))
                    ((eq? type '*set*)             (emit-op 37))
                    ((eq? type '*read*)            (emit-op 38))

                    ;; Stack operations
                    ((eq? type '*swap*)            (emit-op 39))
                    ((eq? type '*rot*)             (emit-op 40))
                    ((eq? type '*dup-ref*)         (emit-op 41))
                    ((eq? type '*drop*)            (emit-op 42))
                    ((eq? type '*depth*)           (emit-op 43))

                    ;; Arithmetic
                    ((eq? type '*add*)             (emit-op 44))
                    ((eq? type '*sub*)             (emit-op 45))
                    ((eq? type '*mul*)             (emit-op 46))
                    ((eq? type '*div*)             (emit-op 47))
                    ((eq? type '*mod*)             (emit-op 48))

                    ;; Numeric comparison
                    ((eq? type '*numeric-equal*)   (emit-op 49))
                    ((eq? type '*numeric-lt*)      (emit-op 50))
                    ((eq? type '*numeric-gt*)      (emit-op 51))

                    ;; Logic
                    ((eq? type '*not*)             (emit-op 52))
                    ((eq? type '*eq*)              (emit-op 53))

                    ;; I/O
                    ((eq? type '*output*)          (emit-op 54))
                    ((eq? type '*fd-read*)         (emit-op 55))
                    ((eq? type '*fd-write*)        (emit-op 56))
                    ((eq? type '*open*)            (emit-op 57))
                    ((eq? type '*close*)           (emit-op 58))
                    ((eq? type '*slurp*)           (emit-op 59))
                    ((eq? type '*asm*)             (emit-op 60))
                    ((eq? type '*import*)          (emit-op 61))
                    ((eq? type '*call-ext*)        (emit-op 62))

                    ;; Type predicates
                    ((eq? type '*is-fixnum*)       (emit-op 63))
                    ((eq? type '*is-bool*)         (emit-op 64))
                    ((eq? type '*is-char*)         (emit-op 65))
                    ((eq? type '*is-symbol*)       (emit-op 67))
                    ((eq? type '*is-vector*)       (emit-op 68))
                    ((eq? type '*is-byte-vector*)  (emit-op 69))
                    ((eq? type '*is-pair*)         (emit-op 71))
                    ((eq? type '*is-empty*)        (emit-op 72))
                    ((eq? type '*is-closure*)      (emit-op 73))
                    ((eq? type '*is-self*)         (emit-op 75))

                    ;; Misc
                    ((eq? type '*set-exit*)        (emit-op 76))
                    ((eq? type '*gc-stats*)        (emit-op 77))

                    ;; Label definition
                    ((eq? type '*label*)           (emit-label target token))

                    ;; Debug directive: consume filename, line, column then skip
                    ((eq? type '*directive-file*)
                        (token-stream)
                        (token-stream)
                        (token-stream))

                    (else
                        (begin
                            (display "Not Implemented: ")
                            (display type)
                            (newline))))
                (emit-asm))))
    (emit-asm)

    ((target-postamble target)))



