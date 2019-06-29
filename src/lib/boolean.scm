;;;
;;; Define some basic boolean operators
;;;

(define (not a) (if a #f #t))

(define (boolean? x) (asm (x) bool?))

;; Check to see that both arguments are booleans
;; and equal
(define (boolean=? x y)
  (and (boolean? x) (boolean? y) (eq? x y)))

;; Check to see that both arguments are strings
;; and equal
(define (string=? x y)
  (and (string? x) (string? y) (eq? x y)))

;; break cycles in equal-pair?
;; TODO: This is very inefficient but will work
(define (equal-seen x seen-x)
  (cond
   ((null? seen-x) #f)
   ((eq? x (car seen-x)) #t)
   (else (equal-seen x (cdr seen-x)))))



;; walk each the tree of pairs
;; TODO: This will have to change to deal with cycles
(define (equal-pair? x y)

  (define (equal-inner x y seen-x seen-y)
    (cond
     ((and (equal-seen x seen-x)
       (equal-seen y seen-y)) #t) ;; We have a cyle

     ((and (null? x) (null? y)) #t) ;; we have two nulls

     (else (and
        (if (and (pair? (car x)) (pair? (car y)))
        (equal-inner (car x)
                 (car y)
                 (cons x seen-x)
                 (cons y seen-y))
        (equal? (car x) (car y)))

        (if (and (pair? (cdr x)) (pair? (cdr y)))
        (equal-inner (cdr x)
                 (cdr y)
                 (cons x seen-x)
                 (cons y seen-y))
        (equal? (cdr x) (cdr y)))))))

  (equal-inner x y '() '()))


;; Check a pair of vectors for equality
(define (equal-vector? x y)
  (equal-pair? (vector->list x)
               (vector->list y)))

;; Check a pair of records or equality
(define (equal-record? x y)
  (equal-pair? (record->list x)
               (record->list y)))

;; Check bytevectors for equality
(define (equal-bytevector? x y)
    (define len-x (bytevector-length x))
    (define len-y (bytevector-length y))

    (define (walk idx x y)
        (cond
            ((eqv? idx len-x) #t)
            ((eqv? (bytevector-u8-ref x idx) (bytevector-u8-ref y idx))
                (walk (+ 1 idx) x y))
            (else #f)))

    (cond
        ((not (eqv? len-x len-y)) #f)
        (else
            (walk 0 x y))))

;; Deep equality checking
(define (equal? x y)
  (cond
    ((and (boolean? x) (boolean? y)) (boolean=? x y))
    ((and (string? x) (string? y)) (string=? x y))
    ((and (pair? x) (pair? y)) (equal-pair? x y))
    ((and (vector? x) (vector? y)) (equal-vector? x y))
    ((and (bytevector? x) (bytevector? y)) (equal-bytevector? x y))
    ((and (record? x) (record? y)) (equal-record? x y))

    ;; if we get here, things are not equal
    (else
     (begin
       (eqv? x y)))))

