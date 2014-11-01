(begin
  (define true 
    (lambda (x y) x))

  (define false
    (lambda (x y) y))
  
  (define if ;; not the correct form of if
    (lambda (test t f)
      (display "IF ")
      (dump-env)
      (test t f)))
      

;;  (define tail-bomb
;;    (lambda (t)
;;      (display #\newline)
;;      (display (depth))
;;      (t t)))
;;
;;  (display (true #t #f))
;;  (display #\newline)

;;  (display (false #t #f))
;;  (display #\newline)

;;  (display (false (false #\a #\b) #\c) )
;;  (display #\newline)

  ;;(display (true #\@ #f))
  ;;(display #\newline)
  (display (if true #\@ #f))
  (display "BOO")

  ;; (tail-bomb tail-bomb)
)
