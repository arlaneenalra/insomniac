;;;
;;; Math operations beyond the basic primitives
;;;

;; TODO:  Expand these to variadic form
(define (and x y)
  (if (eq? x y) x #f))

(define (or x y)
  (if x
    #t
    (if y #t #f)))


(define (>= x y)
  (or
    (> x y)
    (= x y)))

(define (<= x y)
  (or 
    (< x y)
    (= x y)))

