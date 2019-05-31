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
                  0)))

;; Create a vector from an arbitrary list of arguments.
(define (bytevector . args)
    (define (walk-vector args result idx)
        (if (null? args)
            result
            (begin
                (bytevector-u8-set! result idx (car args))
                (walk-vector (cdr args) result (+ 1 idx)))))
    (walk-vector args (make-bytevector (length args)) 0))

(define (bytevector-copier to-factory at from args)
    (core-vector-copier to-factory bytevector-u8-set! bytevector-u8-ref bytevector-length at from args))

;; Copy from one byte vector to another.
(define (bytevector-copy! to at from . args)
    (bytevector-copier (lambda (size) to) at from args))

;; Copy from one byte vector to another.
(define (bytevector-copy from . args)
    (bytevector-copier make-bytevector 0 from args))

;; A basic append
(define (bytevector-append . args)
    (define (len-all size args)
        (if (null? args)
            size
            (len-all (+ size (bytevector-length (car args))) (cdr args))))

    (define dest (make-bytevector (len-all 0 args)))

    (define (inner dest idx args)
        (if (null? args)
            dest
            (begin
                (define len (bytevector-length (car args)))
                (bytevector-copy! dest idx (car args))
                (inner dest (+ idx len) (cdr args)))))

    (inner dest 0 args))

