

;;(define testie
;;  (lambda (val)
;;    (if val
;;      (display "true"))
;;      ;;(display "false"))
;;    (newline)))
;;
;;(testie #t)
;;

(display
  (cond
    ((> -1 0) "first")
    ((> 1 0) "second")
    (else "else"))
)

