;;;
;;; Some simple testing procedures
;;;

;; A very crude test case handler
(define (expect-true name test)
  (display name)

  (if (test)
    (display ":PASSED")
    (begin
      (display ":FAILED")
      (newline)
      (emergency-exit 1)))
  (newline))

(define (expect-false name test)
  (expect-true name
               (lambda () (not (test)))))


