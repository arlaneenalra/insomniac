(define func
  (lambda (x y z) z))

(define func2
  (lambda (x y . z) z))

(display (func2 1 2 3 4))
(display #\newline)

(define x 1)

(define closed
  (lambda ()
    (display x)
    (display #\newline)))

(closed)

(set! x 23)

(closed)


