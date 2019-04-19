;;;
;;; Some simple call/cc tests.
;;;

(include "expect.scm")

(expect "Check that the simplest call/cc works"
    (lambda ()
        (call/cc (lambda (x) (x -1))))
    -1)

(expect "Check something a little more complex"
    (lambda () 
        (call-with-current-continuation
            (lambda (exit) 
                (for-each 
                    (lambda (x) 
                        (if (> 0 x) 
                            (exit x))) 
                    '(54 0 37 -3 245 19)) #t)))
    -3)

