(begin

  ;;(define count 0)

  (define tail-bomb
    (lambda (t)
      (display (depth))
      (display " ")
      (gc-stats)
      "BOOM 1234 1234 1234 1234 1234 1234 12341 234"
      (display 'abcdefgh)

      (let* ((x 1))
          (t t))))

  (tail-bomb tail-bomb)
)
