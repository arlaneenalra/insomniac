;;;
;;; Tests for the equivalence procedures
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


;; Test Cases
(define (equal-suite name predicate)
  (display name)
  (newline)
  (display "==================================================")
  (newline)

  (expect-true "Two Booleans"
               (lambda () (predicate #t #t)))

  (expect-false "Two Booleans not Equal"
                (lambda () (predicate #t #f)))

  (expect-true "Two numbers"
               (lambda () (predicate 1 1)))

  (expect-false "Two numbers not Equal"
                (lambda () (predicate 1 2)))

  (expect-true "Two characters"
               (lambda () (predicate #\A #\A)))

  (expect-false "Two characters not Equal"
                (lambda () (predicate #\A #\a)))

  (expect-false "Different types"
                (lambda () (predicate #f 'nil)))

  (expect-false "Two lists"
                (lambda () (predicate (list 'a) (list 'a))))

  (expect-false "Two pairs"
                (lambda () (predicate (cons 1 2 ) (cons 1 2))))

  (expect-true "Two nulls"
               (lambda () (predicate '() '())))

  (expect-true "The same symbol"
               (lambda () (predicate 'a 'a)))

  (expect-false "Different symbols"
                (lambda () (predicate 'a 'b)))

  (expect-false "Different strings"
               (lambda () (predicate "a" "B")))

  (expect-true "The same string"
               (lambda () (predicate "a" "a")))

  (expect-true "The same procedure"
               (lambda () (predicate car car)))

  (expect-false "Different procedures"
               (lambda () (predicate car cdr)))

  (expect-false "Differnt lambdas"
                (lambda () (predicate
                             (lambda () 1)
                             (lambda () 2))))

  (expect-true "The same list"
               (lambda ()
                 (define x (list 'a))
                 (predicate x x ))))

(equal-suite "Testing eq?" eq?)
(equal-suite "Testing eqv?" eqv?)
