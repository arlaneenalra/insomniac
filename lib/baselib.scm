;;;
;;; Some very basic library functions that are needed by most code
;;;

;; Define type tests
(begin

(define (display x) (asm (x) out ()))

(include "predicates.scm")

;; Functions needed for base test library
;;
;; display
;; write
;; equal?
;; for-each
;; let
;; newline
;; set!
;; define-macro --- maybe
;; 
)
