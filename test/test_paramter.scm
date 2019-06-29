;;;
;;; Test parameters
;;;

(include "../src/lib/test/expect.scm")

(define param (make-parameter 1))

(expect "Test that a parameter returns the default value"
    param 1)

(expect "Test that a parameter can be updated"
    (lambda ()
        (list
            (param)

            (param-wrap param 2
                (lambda ()
                    (list
                        (param)
                        (param-wrap param 3
                            (lambda () (param)))
                        (param))))

            (param)))
    (list 1 (list 2 3 2) 1))
