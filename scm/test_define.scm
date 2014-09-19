(begin
  (define true 
    (lambda (x y) x))

  (define false
    (lambda (x y) y))
  
  (define if
    (lambda (test t f)
      (test t f)))

  ;;(if true #t #f)
  (true #t #f)
)
