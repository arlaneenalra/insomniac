;;;
;;; A set of core list functions
;;;

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

