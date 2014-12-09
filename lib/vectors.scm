;;;
;;; Basic Vector functions
;;;

(define (vector? x) (asm (x) vector?))

;; Return the length of a vector
(define (vector-length x) (asm (x) vec-len))

;; Store a value into the vector
(define (vector-set! vec idx obj)
  (asm (idx) (obj) (vec) vec! ()))

;; Load a value from a vector
(define (vector-ref vec idx)
  (asm (idx) (vec) vec@))

;; Create a vector object of a given size
(define make-vector
  (lambda args
    (define (make-vector-prim k) (asm (k) vector))

    ;; create the vector
    (define vec (make-vector-prim (car args)))

    (if (eq? 2 (length args))
      (vector-fill! vec (car (cdr args)))
      vec)))
