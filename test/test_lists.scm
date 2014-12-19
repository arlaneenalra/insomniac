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

(expect "Add to a list 2"
        (lambda () (cons "a" '(b c d)))
        '("a" b c d))


(next-suite "member tests")

(define test-list '(a b c 1 2 3 "A" "b" "c"))

(expect "member should return a sublist"
        (lambda () (member 3 test-list))
        '(3 "A" "b" "c"))

(expect "memq should return a sublist"
        (lambda () (memq 3 test-list))
        '(3 "A" "b" "c"))

(expect "memv should return a sublist"
        (lambda () (memq 3 test-list))
        '(3 "A" "b" "c"))

(define alist '((a 1) (b 2) (ccc 3)))

(expect "assoc should return the list entry"
        (lambda () (assoc 'b alist))
        '(b 2))

(expect-false "assoc should return false if not found"
          (lambda () (assoc 'd alist)))

