;;;
;;; Some very basic library functions that are needed by most code
;;;

;; Define type tests

;; Functions needed for base test library
;;
;; (x) display
;; write
;; equal?
; for-each
;; let
;; (x) newline
;; (x) set!
;; define-macro --- maybe
;;

(define (display x) (asm (x) out ()))
(define (newline) (asm #\newline out ()))

;; very very crude eq?
(define (eq? a b) (asm (a) (b) eq))
(define eqv? eq?)

;; For cond
(define else #t)

(define (apply proc l . args)
    (define new-args
        (if (null? args)
            l
            (asm (args) (l) cons (append) call_in))) 
    (asm (new-args) (proc) tail_call_in))

(include "dynamic.scm")

(include "math.scm")

(include "predicates.scm")

(include "boolean.scm")

(include "lists.scm")
(include "vectors.scm")
(include "strings.scm")

(include "records.scm")

(include "loop.scm")
(include "call-cc.scm")
(include "parameter.scm")
(include "error.scm")
(include "ports.scm")

