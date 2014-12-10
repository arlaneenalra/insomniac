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

(define (cons car cdr) (asm (cdr) (car) cons))

;; For cond
(define else #t)

(include "math.scm")

(include "predicates.scm")

(include "boolean.scm")

(include "lists.scm")
(include "vectors.scm")

