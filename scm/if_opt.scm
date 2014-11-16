
(define testie
  (lambda (val)
    (if val
      (display "true")
      (display "false"))))

(testie #t)
