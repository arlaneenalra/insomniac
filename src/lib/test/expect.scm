;;;
;;; Some simple testing procedures
;;;

(define (next-suite name)
  (display "Running: ")
  (display name)
  (newline)
  (display "==================================================")
  (newline))

(define (fail)
  (display ":FAILED")
  (newline)
  (emergency-exit 1))

(define (pass)
  (display ":PASSED")
  (newline))

;; A very crude test case handler
(define (expect-true name test)
  (display name)

  (if (test) (pass) (fail)))

(define (expect-false name test)
  (expect-true name
               (lambda () (not (test)))))

(define (expect name test expected)
  (display name)
  (define result (test))

  (if (equal? result expected)
    (pass)
    (begin
      (newline)
      (display " Expected: ")
      (display expected)
      (newline)
      (display " Result  : ")
      (display result)
      (newline)
      (fail))))

;; Utility function to simplify using an input string.
(define (call-with-input str thunk)
    (lambda ()
        (with-input-port
            (open-input-string str)
            thunk)))

