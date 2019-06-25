;;;
;;; The core of a simple lexical analyzer.
;;;

;; Returns a generator for the current input stream.
(define (char-stream blk-size)
    (define stream '())

    (define (read-block)
        (let*
            ((str (read-string blk-size)))
            (if (string? str)
                (string->list str)
                str)))

    (define (next-char)
        (cond 
            ((eof-object? stream) stream)
            ((null? stream)
                (begin
                    (set! stream (read-block))
                    (define c (next-char))
                    c))
            (else
                (begin
                    (define c (car stream))
                    (set! stream (cdr stream))
                    c))))
    next-char) 

