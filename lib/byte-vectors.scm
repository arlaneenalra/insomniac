;;;
;;; Basic Byte Vector functions
;;;

(define (bytevector? x) (asm (x) vector-u8?))

;; Return the length of a vector
(define (bytevector-length x) (asm (x) vec-len))

;; Store a value into the vector
(define (bytevector-u8-set! vec idx obj)

  (asm (idx) (obj) (vec) idx! ()))

;; Load a value from a vector
(define (bytevector-u8-ref vec idx)
  (asm (idx) (vec) idx@))

;; Fills a vector with the given object
(define (bytevector-fill! vec fill)
  (define (inner index)
    (if (>= index 0) ;;;; TODO - >= not defined
      (begin
        (bytevector-u8-set! vec index fill)
        (inner (- index 1)))
      vec))
  (inner (- (vector-length vec) 1)))


;; Create a vector object of a given size
(define (make-bytevector . args)
  (define (make-bytevector-prim k) (asm (k) vector-u8))

  ;; create the vector
  (bytevector-fill! (make-bytevector-prim (car args))
                (if (eq? 2 (length args))
                  (car (cdr args))
                  '())))

