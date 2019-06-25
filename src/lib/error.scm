;;;
;;; Very basic exception handling
;;;

(define current-exception-handler
    (make-parameter
        (lambda (obj)
            (display "Caught exception: ")
            (display (error-object-message obj))
            (newline)
            (display (error-object-irritants obj))
            (newline))))


(define-record-type <error>
    (make-error message irritants)
    error-object?
    (message error-object-message)
    (irritants error-object-irritants))


(define (error message . irritants)
    (raise
        (make-error message irritants)))

(define (raise obj)
    ((current-exception-handler) obj)
    (let*
        ((message (error-object-message obj))
         (irritants (error-object-irritants obj)))
        
        (asm (message) (irritants) throw)))

(define (raise-continuable obj)
    ((current-exception-handler) obj))
   
(define (with-exception-handler handler thunk)
    (param-wrap current-exception-handler hanlder think))

