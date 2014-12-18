;;;
;;; Test basic list and pair functions
;;;

(include "expect.scm")


;; Testing pair?
(next-suite "pair? tests")

(expect-true "A pair of symbols"
             (lambda () (pair? '(a . b))))

(expect-true "A simple list"
             (lambda () (pair? '(a b c))))

(expect-false "The empty list"
              (lambda () (pair? '())))

(expect-false "A vector"
              (lambda () (pair? (make-vector 10))))


(next-suite "cons tests")

(expect-true "Make a list"
             (lambda ()
               (equal?
                 (cons 'a '())
                 '(a))))


