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

(include "mac-x64.scm")


;; Emit code for the given target defined by the given token stream.
(define (assemble target token-stream)
    ;; Ouput the preamble
    ((target-preamble target))

    (define (emit-asm)
        (define token (token-stream))
        (define type (token-type token))

        (if (eq? type '*EOF*)
            #t
            (begin
                (cond
                    ((eq? type '*fixnum-literal*)
                        (emit-fixnum target token))
                    ((eq? type '*string-literal*)
                        (emit-string target token))
                    ((eq? type '*char-literal*)
                        (emit-char target token)) 

                    ((eq? type '*drop*)
                        (emit-drop target token))
                    
                    ((eq? type '*call*)
                        (emit-call target token))
                    ((eq? type '*jmp*)
                        (emit-jmp target token))

                    ((eq? type '*label*)
                        (emit-label target token))

                    ((eq? type '*fd-write*)
                        (emit-write target token))

                    (else
                        (begin
                            (display "Not Implemented! ")
                            (display token)
                            (newline))))
                (emit-asm))))
    (emit-asm)

    ((target-postamble target)))



