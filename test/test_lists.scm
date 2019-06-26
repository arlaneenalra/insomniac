;;;
;;; Test basic list and pair functions
;;;

(include "../src/lib/test/expect.scm")

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

(expect "assoc should return the list entry"
        (lambda () (assoc 'a alist))
        '(a 1))

(expect-false "assoc should return false if not found"
              (lambda () (assoc 'd alist)))


(expect "assq should return the list entry"
        (lambda () (assq 'b alist))
        '(b 2))

(expect "assq should return the list entry"
        (lambda () (assq 'a alist))
        '(a 1))

(expect-false "assq should return false if not found"
              (lambda () (assq 'd alist)))

(expect-false "assq should use eq?"
              (lambda () (assq (list 'a) '(((a)) ((b)) ((c))))))

(expect "assoc should use equal?"
        (lambda () (assoc (list 'a) '(((a)) ((b)) ((c)))))
        '((a)))

(expect "assv should use eqv?"
        (lambda () (assv 5 '((2 3) (5 7) (11 13))))
        '(5 7))

;; Test list-copy
(next-suite "list-copy tests")

(expect "list-copy should create a different list"
    (lambda ()
        (let*
            ((a '(1 8 2 8))
             (b (list-copy a)))
            
            (set-car! b 3)
            (list a b)))
    '((1 8 2 8) (3 8 2 8)))

;; Test append
(next-suite "append tests")

(expect "append should combind 2 lists"
    (lambda ()
        (append '(x) '(y)))
    '(x y))

(expect "append should combind 2 lists of different sizes"
    (lambda ()
        (append '(a) '(b c d)))
    '(a b c d))

(expect "append allow lists of lists"
    (lambda ()
        (append '(a (b)) '((c))))
    '(a (b) (c)))

(expect "append should allow things that are not true lists"
    (lambda ()
        (append '(a b) '(c . d)))
    '(a b c . d))

(expect "append should take '() 'a and return a"
    (lambda ()
        (append '() 'a))
    'a)

(expect "Verify that flatten works right"
    (lambda ()
        (flatten
            (list 1 2 3 
                (list 4 5 6 
                    (list 7 8 9)
                    '(10 . 11))
                12 13 14)))
    (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14)) 

(expect "Verify that flatten returns a list when given a non-list"
    (lambda ()
        (flatten #\A))
    (list #\A))

