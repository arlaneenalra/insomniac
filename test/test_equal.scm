;;;
;;; Tests for the equivalence procedures
;;;

(include "../lib/test/expect.scm")

(define a '(1 2 3 4))
(define b '(1 2 3 4))
(define c '(1 2 3 ))

(define a-str '("a" b c d))
(define a2-str '("a" b c d))
(define b-str '("b" b c d))

(define vec-a (vector 1 2 3 4))
(define vec-b (vector 1 2 3 4))
(define vec-c (vector 1 2 3))

(define abc (cons a (cons b (cons c '()))))
(define ABC (cons a (cons b (cons c '()))))
(define acb (cons a (cons c (cons b '()))))

;; Construct a cycle
(define (make-cycle-cdr)
  (define cycle (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 '()))))))
  (define cycle-tail (cdr (cdr (cdr (cdr cycle)))))
  (set-cdr! cycle-tail cycle)
  cycle)

(define (make-cycle-car)
  (define cycle (cons (cons (cons (cons (cons 5 '()) 4) 3) 2) 1))
  (define cycle-tail (car (car (car (car cycle)))))
  (set-car! cycle-tail cycle)
  cycle)


(define cycle-a (make-cycle-cdr))
(define cycle-b (make-cycle-cdr))
(define cycle-c (make-cycle-cdr))

(define cycle-a-a (make-cycle-car))
(define cycle-b-a (make-cycle-car))
(define cycle-c-a (make-cycle-car))

;; TODO: Redo after let is added
((lambda (cycle-c-tail)
   (set-cdr! cycle-c-tail a))
 (cdr (cdr (cdr cycle-c))))

((lambda (cycle-c-tail)
   (set-car! cycle-c-tail a))
 (car (car (car cycle-c-a))))

;; Test cases
(expect-true "Two nulls"
             (lambda () (equal? '() '())))

(expect-true "The same list"
             (lambda () (equal? a a)))

(expect-true "Equivalent list"
             (lambda () (equal? a b)))

(expect-true "Equivalent list, transitive"
             (lambda () (equal? b a)))

(expect-false "Different list"
             (lambda () (equal? c a)))

(expect-false "Different list, tranitive"
             (lambda () (equal? a c)))

(expect-true "The same list"
             (lambda () (equal? abc abc)))

(expect-true "Equivalent lists"
             (lambda () (equal? abc ABC)))

(expect-true "Equivalent lists, transitive"
             (lambda () (equal? ABC abc)))

(expect-false "Different lists"
              (lambda () (equal? acb abc)))

(expect-false "Different lists, transitive"
              (lambda () (equal? abc acb)))

(expect-false "Number lists to symbols"
              (lambda () (equal? abc a)))

(expect-true "Strings and symbols in lists"
             (lambda () (equal? a-str a2-str)))

(expect-false "Strings and symbols in lists"
              (lambda () (equal? a-str b-str)))


(expect-true "Same cycle"
             (lambda () (equal? cycle-a cycle-a)))

(expect-true "Equivalent cycle"
             (lambda () (equal? cycle-a cycle-b)))

(expect-true "Equivalent cycle, transitive"
             (lambda () (equal? cycle-b cycle-a)))

(expect-false "Different cycles"
              (lambda () (equal? cycle-c cycle-a)))

(expect-false "Different cycles, transitive"
              (lambda () (equal? cycle-a cycle-c)))

(expect-true "Same double cycle"
             (lambda () (equal? cycle-a-a cycle-a-a)))

(expect-true "Equivalent double cycle"
             (lambda () (equal? cycle-a-a cycle-b-a)))

(expect-true "Equivalent double cycle, transitive"
             (lambda () (equal? cycle-b-a cycle-a-a)))

(expect-false "Different double cycle"
              (lambda () (equal? cycle-c-a cycle-a-a)))

(expect-false "Different double cycle, transitive"
              (lambda () (equal? cycle-a-a cycle-c-a)))

(expect-true "Same Vectors"
             (lambda () (equal? vec-a vec-a)))

(expect-true "Equivalent Vectors"
             (lambda () (equal? vec-a vec-b)))

(expect-true "Equivalent Vectors, transitive"
             (lambda () (equal? vec-b vec-a)))

(expect-false "Different Vectors"
              (lambda () (equal? vec-c vec-a)))

(expect-false "Different Vectors, transitive"
              (lambda () (equal? vec-a vec-c)))

