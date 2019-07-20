;;;
;;; Code generation primitives.
;;;

(define (abi-register-builder ret abi-registers)
    (lambda (idx)
        (if (eq? idx '*ret*)
            ret
            (vector-ref abi-registers idx))))
 

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



