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

;; The guts of the copy operation.
(define bytevector-copier
    (begin
        (define (add x) (+ x 1))
        (define (sub x) (- x 1))

        (lambda (to-factory at from args)
            (define start 0)
            (define end (bytevector-length from))

            (define (process-args sym args)
                (if (or (null? args) (null? sym))
                    #t
                    (begin
                        (set! (car sym) (car args))
                        (process-args (cdr sym) (cdr args)))))
            (process-args '(start end) args)

            (define to-copy (- end start))

            (define to (to-factory to-copy))

            (define (inner at start dir num)
                (if (> 0 num )
                    to
                    (begin
                        (bytevector-u8-set! to at
                            (bytevector-u8-ref from start))
                        (inner (dir at) (dir start) dir (- num 1 )))))

            (if (> start at)
                (inner at start add (- to-copy 1))
                (begin
                    (set! to-copy (- to-copy 1))
                    (inner (+ at to-copy) (+ start to-copy) sub to-copy))))))

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

