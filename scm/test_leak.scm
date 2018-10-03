(begin

  (define tail-bomb
    (lambda (t)
      (display (depth))
      (display " ")
      (gc-stats)
      "BOOM"
      (display 'abcdefgh)
      (t t)))

  (tail-bomb tail-bomb)
)
