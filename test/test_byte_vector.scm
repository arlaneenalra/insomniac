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
        (bytevector-copy! dest 0 source)
        dest)
    (bytevector 1 2 3 4 5 0))

(expect "Check that copy! with a different from works"
    (lambda ()
        (define source (bytevector 1 2 3 4 5))
        (define dest (make-bytevector 6))
        (bytevector-copy! dest 1 source)
        dest)
    (bytevector 0 1 2 3 4 5))

(expect "Check that copy! works right with overlap in the other direction"
    (lambda ()
        (define source (bytevector 1 2 3 4 5))
        (define dest (bytevector 10 20 30 40 50))
        (bytevector-copy! dest 1 source 0 2)
        dest)
    (bytevector 10 1 2 40 50))

(expect "Check that copy! works right with overlap"
    (lambda ()
        (define source (bytevector 1 2 3 4 5 6))
        (bytevector-copy! source 0 source 2 5)
        source)
    (bytevector 3 4 5 4 5 6))

(expect "Check that copy! works right with overlap in the other direction"
    (lambda ()
        (define source (bytevector 1 2 3 4 5 6))
        (bytevector-copy! source 2 source 0 5)
        source)
    (bytevector 1 2 1 2 3 4))

(expect "Check that the new allocation version of copy works"
    (lambda ()
        (define source (bytevector 1 2 3 4 5))
        (define dest (bytevector-copy source 2 4))
        (cons source dest))
        (cons (bytevector 1 2 3 4 5) (bytevector 3 4)))

(expect "Validate append"
    (lambda ()
        (bytevector-append (bytevector 0 1 2) (bytevector 3 4 5) (bytevector 6 7 8)))
    (bytevector 0 1 2 3 4 5 6 7 8))

