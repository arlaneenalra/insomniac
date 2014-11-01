(begin
  (define true 
    (lambda (x y) x))

  (define false
    (lambda (x y) y))
  
  (define if ;; not the correct form of if
    (lambda (test t f)
      (test t f)))

  (define tail-bomb
    (lambda (t)
      (display (depth))
      (display " ")
      (gc-stats)
      (t t)))

  (display (true #t #f))
  (display #\newline)

  (display (false #t #f))
  (display #\newline)

  (display (false (false #\a #\b) #\c) )
  (display #\newline)

  (display (true #\@ #f))
  (display #\newline)

  (display
    (if true
      (quote (#\@))
      (quote (undefined #f))))

  (display #\newline)

  (tail-bomb tail-bomb)
)
