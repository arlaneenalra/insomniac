

;;(define testie
;;  (lambda (val)
;;    (if val
;;      (display "true"))
;;      ;;(display "false"))
;;    (newline)))
;;
;;(testie #t)
;;

;;(display 123)

(display
  (cond
    ((> -1 0) "first")
    ((> 1 0) "second")
    (else "else"))
)


(define (boom) (asm 1234))

(define boom-2 
  (lambda () (asm 1234)))
