(begin
  (define true 
    (lambda (x y) x))

  (define false
    (lambda (x y) y))
  
  (define if
    (lambda (test t f)
      (dump-env)
      (test t f)))

  ;;(display (true #t #f))
  ;;(display #\newline)

  ;;(display (false #t #f))
  ;;(display #\newline)

;;  (display (false #\a #\b) )
  (display #\newline)
  (false (false #\a #\b) #\c)
)
