;;;
;;; Define parameter objects
;;;

;; This implementations is roughly the same as the reference
;; implmenetation in the r7rs docs.
(define (make-parameter init . arg)
    (define converter
        (if (pair? arg)
            (car arg)
            (lambda (x) x)))

    (define value (converter init))

    (lambda ( . args)
        (cond
            ((null? args)   value)
            ((eq? (car args) '<param-set!>)
                (set! value (car (cdr args))))
            ((eq? (car args) '<param-convert>)
                converter)
            (else
                (error "bad parameter syntax")))))

;; We don't have define-syntax yet.
(define (param-wrap param value thunk)
    (define old (param))
    (define new ((param '<param-convert>) value))

    (dynamic-wind
        (lambda ()
            (param '<param-set!> value))
        thunk
        (lambda ()
            (param '<param-set!> old))))

