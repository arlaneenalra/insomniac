(begin
  (define y 1)
  (define x 2)

  (display
    (if #f 'true (if (> x y) 'false-true 'false-false)))

  (display #\newline)

  (display '(1 2 3 4))
  (display #\newline)

  (display '(1 2 3 . 4))
  (display #\newline)

  (display '(1 3 . ()))
  (display #\newline)
  (display '())
)

