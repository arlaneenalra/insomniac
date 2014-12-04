(begin

  (define true 
    (lambda (x y) x))

  (define false
    (lambda (x y) y))
  
  ;; the primitive eval implements if
  ;; internally
  (define my-if 
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
    (my-if true
      '(#\@)
      '(undefined #f)))

  (display #\newline)

  (tail-bomb tail-bomb)
)
