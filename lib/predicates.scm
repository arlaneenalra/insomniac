;;;
;;; Type testing predicates 
;;;

(define (fixnum? x) (asm (x) fixnum?))

(define (bool? x) (asm (x) bool?))

(define (char? x) (asm (x) char?))

(define (string? x) (asm (x) string?))

(define (vector? x) (asm (x) vector?))

(define (pair? x) (asm (x) pair?))

(define (null? x) (asm (x) null?))

(define (proc? x) (asm (x) proc?))

(define (symbol? x) (asm (x) symbol?))


