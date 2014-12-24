(begin

  (define tail-bomb
    (lambda (t)
      (display (depth))
      (display " ")
      (gc-stats)
      "BOOM"
      (t t)))

  (tail-bomb tail-bomb)
)
