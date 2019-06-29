;;;
;;; Tests for basic boolean operations
;;;

(include "../src/lib/test/expect.scm")

(display "Testing not:")
(newline)

(expect-false "True becomes false"
             (lambda () (not #t)))

(expect-true "False becomes true"
             (lambda () (not #f)))

(expect-false "Numbers are true - and become false"
              (lambda () (not 3)))

(expect-false "Lists are true - and become false"
              (lambda () (not (list 3))))

(expect-false "Even empty Lists are true - and become false"
              (lambda () (not '())))

(expect-false "Even empty Lists are true - and become false"
              (lambda () (not (list))))

(expect-false "Symbols are true - and become false"
              (lambda () (not 'nil)))

(display "Testing boolean?:")
(newline)

(expect-true "True is a boolean"
             (lambda () (boolean? #t)))

(expect-true "False is a boolean"
             (lambda () (boolean? #f)))

(expect-false "Numbers are not booleans"
             (lambda () (boolean? 0)))

(expect-false "Lists are not booleans"
             (lambda () (boolean? '())))

(display "Testing boolean=?:")
(newline)

(display "Testing and:")
(newline)

(expect-true "Should return true with no arguments"
             (lambda () (and)))

(expect-true "Should return true when passed true"
             (lambda () (and #t)))

(expect-true "Should return true when passed true, true"
             (lambda () (and #t #t)))

(expect-true "Should return true when passed true, true, true"
             (lambda () (and #t #t #t)))

(expect-false "Should return false when passed false"
             (lambda () (and #f)))

(expect-false "Should return false when passed true, false"
             (lambda () (and #t #f)))

(expect-false "Should return false when passed true, false, true"
             (lambda () (and #t #f #t)))

(expect-false "Should return false when passed true, true, true, false"
             (lambda () (and #t #t #t #f)))

(expect-true "Should short-circuit on first false"
             (lambda ()
               (define result #f)
               (and (set! result #t) #f (set! result #f))
               result))

(expect "Should return the first false expression"
        (lambda ()
          (and 1 2 'c '(f g))) '(f g))

(newline)

(display "Testing or:")
(newline)

(expect-false "Should return false with no arguments"
             (lambda () (or)))

(expect-true "Should return true when passed true"
             (lambda () (or #t)))

(expect-true "Should return true when passed true, true"
             (lambda () (or #t #t)))

(expect-true "Should return true when passed true, true, true"
             (lambda () (or #t #t #t)))

(expect-false "Should return false when passed false"
             (lambda () (or #f)))

(expect-false "Should return false when passed false, false"
             (lambda () (or #f #f)))

(expect-false "Should return false when passed false, false, false"
             (lambda () (or #f #f #f)))

(expect-true "Should return true when passed true, true, true, false"
             (lambda () (or #t #t #t #f)))

(expect-true "Should return true when passed false, false, false, true"
             (lambda () (or #f #f #f #t)))

(expect-true "Should short-circuit on first true"
             (lambda ()
               (define result #f)
               (or (set! result #t) #t (set! result #f))
               result))

(expect "Should return the first true expression"
        (lambda ()
          (or #f '(b c) (/ 3 0))) '(b c))

(expect-true "null? should return true on '()"
    (lambda () (null? '())))

(expect-false "null? should return false on #f"
   (lambda () (null? #f)))

