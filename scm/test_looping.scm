(begin
  (define loop
    (lambda (x loop)
      (display "Counting down from ")
      (display x)
      (display " ")
      ;;(gc-stats)
      (display #\newline)
      (if (< 0 x)
        (loop (- x 1) loop)
        (begin
          (display "Done")
          (display #\newline)))))

  (loop 400000 loop)
)
