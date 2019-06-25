;;;
;;; The core of a simple lexical analyzer.
;;;

;; Returns a generator for the current input stream.
(define (char-stream)
    (define stream '())

    (define (read-block)
        (let*
            ((str (read-string 4096)))
            (if (string? str)
                (string->list str)
                str)))

    (define (next-char)
        (cond 
            ((eof-object? stream) stream)
            ((null? stream)
                (begin
                    (set! stream (read-block))
                    (next-char)))
            (else
                (begin
                    (define c (car stream))
                    (set! stream (cdr stream))
                    c))))
    next-char) 

