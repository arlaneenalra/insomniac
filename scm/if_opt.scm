
(include "./test_tail.scm")

(define testie
  (lambda (val)
    (if val
      (display "true")
      (display "false"))
    (newline)))

(testie #t)

