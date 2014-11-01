(begin
  (define do-op
    (lambda (op x y)
      (display (op x y))
      (display #\newline)))

  (do-op + 1 2)
  (do-op - 1 2)
  (do-op - 2 1)

  (do-op * 2 3)

  (do-op / 7 2)

  (do-op % 7 2)

  (do-op > 7 2)
  (do-op > 2 7)

  (do-op < 7 2)
  (do-op < 2 7)

  (display "EQ:")
  (display #\newline)

  (do-op eq 5 5)
  (do-op eq 4 5)
  (do-op eq 5 4)

  (do-op eq 'a 'a)
  (do-op eq 'b 'a)
)
