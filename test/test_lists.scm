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

(expect "Make a list"
        (lambda () (cons 'a '()))
        '(a))

(expect "Add to a list"
        (lambda () (cons '(a) '(b c d)))
        '((a) b c d))

(display (cons "a" '(b c d)))
(newline)

(expect "Add to a list 2"
        (lambda () (cons "a" '(b c d)))
        '("a" b c d))


