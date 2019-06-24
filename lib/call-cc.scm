;;;
;;; Call/cc and friends
;;;

(define dynamic-wind-before '())

(define (dynamic-wind before thunk after)
    (define result #f)

    (define capture dynamic-wind-before)

    (set! dynamic-wind-before (cons before dynamic-wind-before))
    (before)

    (set! result (thunk))

    (after)
    (set! dynamic-wind-before capture)

    result)

(define (dynamic-wind-enter wrappers)
    (if (null? wrappers)
        #f
        (begin
            (apply (car wrappers) '())
            (dynamic-wind-enter (cdr wrappers)))))

(define (call/cc proc)
    (define capture (reverse dynamic-wind-before))

    (prim-call/cc
        (lambda (exit)
            (proc (lambda (val)
                (dynamic-wind-enter capture)
                (exit val))))))

(define call-with-current-continuation call/cc)

