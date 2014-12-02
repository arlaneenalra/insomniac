
(begin

  (define tail-bomb
    (lambda (t n)
      (display (depth))
      (display " ")
      (display n)
      (display " - ")
      (gc-stats)
      (if (< n 0)
        '()
        (t t (- n 1)))))


  (display (tail-bomb tail-bomb 1000000))
)
