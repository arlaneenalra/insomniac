(begin 
  (define true 
    (lambda (x y) x))
  (define false
    (lambda (x y) y))
  
  (define if
    (lambda (test t f)
      (dump-env)))

  (if true #t #f)
)
