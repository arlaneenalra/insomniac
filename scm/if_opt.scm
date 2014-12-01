
(define testie
  (lambda (val)
    (if val
      (display "true")
      (display "false"))
    (display #\newline)
    ))

(testie #t)
