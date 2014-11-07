;;;
;;; Some very basic library functions that are needed by most code
;;;

;; Define type tests
(begin

(define fixnum?
  (lambda (x) (asm (x) fixnum?)))

(define bool?
  (lambda (x) (asm (x) bool?)))

(define char?
  (lambda (x) (asm (x) char?)))

(define string?
  (lambda (x) (asm (x) string?)))

(define vector?
  (lambda (x) (asm (x) vector?)))

(define pair?
  (lambda (x) (asm (x) pair?)))

(define null?
  (lambda (x) (asm (x) null?)))

(define proc?
  (lambda (x) (asm (x) proc?)))

(define symbol?
  (lambda (x) (asm (x) symbol?)))


)
