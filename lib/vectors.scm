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

;; Fills a vector with the given object
(define (vector-fill! vec fill)
  (define (inner index)
    (if (>= index 0) ;;;; TODO - >= not defined
      (begin
        (vector-set! vec index fill)
        (inner (- index 1)))
      vec))
  (inner (- (vector-length vec) 1)))


;; Create a vector object of a given size
(define (make-vector . args)
  (define (make-vector-prim k) (asm (k) vector))

  ;; create the vector
  (vector-fill! (make-vector-prim (car args))
                (if (eq? 2 (length args))
                  (car (cdr args))
                  '())))

;; Convert the given list into a vector
(define (list->vector list)
  (define vec 
    (make-vector (length list)))

  (define (inner list index)
    (if (null? list)
	vec
	(begin
	  (vector-set! vec index (car list))
	  (inner (cdr list) (+ 1 index)))))
  (inner list 0))


;; Convert a vector to a list
(define (vector->list vec)
  (define (inner list index)
    (if (>= index (vector-length vec))
	(reverse list)
	(inner (cons (vector-ref vec index) list) (+ 1 index))))
  (inner '() 0))

;; Create a vector containing the passed in arguments
(define (vector . list)
  (list->vector list))

