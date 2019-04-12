;;;
;;; Byte Vector tests
;;;

(include "expect.scm")

(define vec (make-bytevector 100 43))

(expect-true "Check that bytevector? Can detect a byte vector"
    (lambda () (bytevector? vec)))

(expect-false "Check that bytevector? Can tell when something isn't a byte vector"
    (lambda () (bytevector? "test")))

(expect-false "Check that bytevector? Can tell that a vector isn't a byte vector"
    (lambda () (bytevector? (make-vector 10))))

(expect-false "Check that a bytevector is not a vector"
    (lambda () (vector? vec)))

(define simple-vec (make-bytevector 10))

(expect-true "Check that the simple form of make-bytevector works"
    (lambda () (bytevector? simple-vec)))

(expect "Check that (bytevector) creates an empty bytvector"
    (lambda () (bytevector) )
    (make-bytevector 0))

;; Setup a compairson vector
(define u8-expected (make-bytevector 3))
(bytevector-u8-set! u8-expected 0 1)
(bytevector-u8-set! u8-expected 1 2)
(bytevector-u8-set! u8-expected 2 0)

(expect "Check that (bytevector) can create a vector with actual values"
    (lambda () (bytevector 1 2 0) )
    u8-expected)

(expect "Check that copy! works"
    (lambda ()
        (define source (bytevector 1 2 3 4 5))
        (define dest (make-bytevector 6)) 
        (bytevector-copy! dest source 0)
        dest)
    (bytevector 1 2 3 4 5 0))


