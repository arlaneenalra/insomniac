(begin
  (define true 
    (lambda (x y) x))

  (define false
    (lambda (x y) y))
  
  (define if
    (lambda (test t f)
      (test t f)))

;;  (display (true #t #f))
;;  (display #\newline)

;;  (display (false #t #f))
;;  (display #\newline)

;;  (display (false (false #\a #\b) #\c) )
;;  (display #\newline)

  (display (if true (if false #t #\@) #f))
  (display #\newline)
)
