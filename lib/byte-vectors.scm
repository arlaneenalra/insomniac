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

;; Create a vector from an arbitrary list of arguments.
(define (bytevector . args)
    (define (walk-vector args result idx)
        (if (null? args)
            result
            (begin
                (bytevector-u8-set! result idx (car args))
                (walk-vector (cdr args) result (+ 1 idx)))))
    (walk-vector args (make-bytevector (length args)) 0))

;; Copy from one byte vector to another.
(define (bytevector-copy! to at from . args)
    (define start 0)
    (define end (- (bytevector-length from) 1))

    (define (process-args sym args)
        (if (or (null? args) (null? sym))
            #t 
            (begin
                (set! (car sym) (car args))
                (process-args (cdr sym) (cdr args)))))
    (process-args '(start end) args)

    (define (inner to at from start end)
        (if (> start end)
            #t
            (begin
                (bytevector-u8-set! to at 
                    (bytevector-u8-ref from start))
                (inner to (+ 1 at ) from (+ 1 start) end))))
    (inner to at from start end))

