;;;
;;; Math operations beyond the basic primitives
;;;

;; and/or are variadic and have to be short-circuit
;;(define (and x y)
;;  (if (eq? x y) x #f))
;;(define (or x y)
;;  (if x #t (if y #t #f)))


(define (>= x y)
  (or
    (> x y)
    (= x y)))

(define (<= x y)
  (or 
    (< x y)
    (= x y)))

