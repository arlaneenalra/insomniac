;;;
;;; A set of core list functions
;;;

(define (cons car cdr) (asm (cdr) (car) cons))

(define (set-car! pair obj) (asm (pair) (obj) set-car))
(define (set-cdr! pair obj) (asm (pair) (obj) set-cdr))

(define list (lambda x x))


;; find the length of a list
(define (length list)
  (define (inner list len) 
    (if (null? list)
      len
      (inner (cdr list) (+ 1 len))))
  (inner list 0))

;; reverse a list
(define (reverse list)
  (define (inner list rev-list)
    (if (null? list)
      rev-list
      (inner (cdr list)
             (cons (car list) rev-list))))
  (inner list '()))


;; Find a sub list 
(define (member obj list . pred)

  (set! pred
    (if (null? pred) equal? (car pred)))

  (cond
    ;; obj not found
    ((null? list) #f)

    ;; test element using pred or equal?
    ((pred (car list) obj) list)

    (else (member obj (cdr list) pred))))

;; memq uses eq?
(define (memq obj list)
  (member obj list eq?))

(define (memv obj list)
  (member obj list eqv?))


;; Functions for dealing with an associative list
(define (assoc obj alist . compare)
  (set! compare 
    (if (null? compare) equal? (car compare)))

  (define entry
    (member obj alist
            (lambda (key b) (compare (car key) b))))

  (if entry
    ;; member returns a tail, all we need is the entry
    (car entry)
    #f))
              


