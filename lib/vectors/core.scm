;;;
;;; Common functionality between different types of vectors
;;;

;; The guts of the copy operation.
(define core-vector-copier
    (begin
        (define (add x) (+ x 1))
        (define (sub x) (- x 1))

        (lambda (to-factory v-set! v-ref v-length at from args)
            (define start 0)
            (define end (v-length from))

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
                        (v-set! to at
                            (v-ref from start))
                        (inner (dir at) (dir start) dir (- num 1 )))))

            (if (> start at)
                (inner at start add (- to-copy 1))
                (begin
                    (set! to-copy (- to-copy 1))
                    (inner (+ at to-copy) (+ start to-copy) sub to-copy))))))


