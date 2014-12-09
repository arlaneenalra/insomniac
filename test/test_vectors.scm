;;;
;;; Vector tests
;;;

(include "expect.scm")


;; Verify that make-vector actually creates a vector
(define my-vec (make-vector 10))

(expect-true "Check that make-vector returns a vector"
             (lambda () (vector? my-vec)))

(expect-true "Check that vector-length actually returns the length"
             (lambda () (eq? 10 (vector-length my-vec))))

(vector-set! my-vec 3 #\c)

(expect-true "Verify vector-set! and vector-ref"
             (lambda () (eq? #\c (vector-ref my-vec 3)))) 
