(define vec (make-bytevector 100 43))
(display vec)

(bytevector-u8-set! vec 1 100)
(display vec)

