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

(define filled-vec (make-vector 30 #\d))

(define (check-vec vec value depth)
  (if (= 0 depth)
    #t
    (if (eq? value (vector-ref vec depth))
      (check-vec vec value (- depth 1))
      #f)))

(expect-true "Verify two argument make-vector"
             (lambda ()
               (check-vec filled-vec #\d
                          (- (vector-length filled-vec) 1))))

;; list->vector tests
(define source-list '(a b c 1 2 3))
(define vec-list (list->vector source-list))

(expect-true "Verify that list->vector produces a vector"
             (lambda () (vector? vec-list)))

;; TODO: come back to this when I have equal? fully implemented
(expect-true "Verify that contains the expected values"
             (lambda ()
               (define (test-me vec idx list)
                 (if (and (null? list)
                          (= idx (vector-length vec)))
                   #t
                   (if (eq? (vector-ref vec idx) (car list))
                     (test-me vec (+ 1 idx) (cdr list))
                     #f)))
               (test-me vec-list 0 source-list)))

