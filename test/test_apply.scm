;;;
;;; Test Apply
;;;

(include "../src/lib/test/expect.scm")

(expect "Verify that apply appends to the list of args"
    (lambda ()
        (apply list (list 1 2 3) (list 4 5 6)))
    (list 1 2 3 4 5 6))

(expect "Verify that apply feeds a list to the proc as expected"
    (lambda ()
        (apply list (list 1 2 3)))

    (list 1 2 3))

(expect "That a simple apply works"
    (lambda ()
        (apply (lambda (x y ) (+ x y)) (list 1 2)))
    3)

(define (div30 x) (/ x 30))
(define (mul x y) (* x y ))

(define compose
    (lambda (f g)
        (lambda args
            (f (apply g args)))))

(expect "Check a more complex example"
    (lambda ()
        ((compose div30 mul) 12 75))
    30)

