;;;
;;; Test Apply
;;;

(include "expect.scm")

(expect "Verify that apply feeds a list to the proc as expected"
    (lambda ()
        (apply list (list 1 2 3)))

    (list 1 2 3))

(expect "Verify that apply appends to the list of args"
    (lambda ()
        (apply list (list 1 2 3) 4 5 6)
    (list 1 2 3 4 5 6)))

