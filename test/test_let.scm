;;;
;;; Test Let and friends
;;;


(include "expect.scm")

(expect "Test Let*"
    (lambda ()
        (define x 2)
        (define y 3)

        (let* ((x 7)
               (z (+ x y)))

              (* z x)))
    70)

