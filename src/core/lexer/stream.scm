;;;
;;; A Replayable stream of characters
;;;

;; Returns a generator for the current input stream.
;; Calling the generator with a character argument puts that character back
;; on the stream
(define (char-stream blk-size)
    (define stream '())

    (define (read-block)
        (let*
            ((str (read-string blk-size)))
            (if (string? str)
                (string->list str)
                str)))

    (define (next-char . args)
        (cond 
            ;; Put a character at the head of the stream
            ((not (null? args))
                (set! stream (cons (car args) stream)))
            
            ;; Are we at the end fo the file?
            ((eof-object? stream) stream)

            ;; Are we at the end of a block?
            ((null? stream)
                (begin
                    (set! stream (read-block))
                    (define c (next-char))
                    c))

            ;; Return the next character in the stream.
            (else
                (begin
                    (define c (car stream))
                    (set! stream (cdr stream))
                    c))))
    next-char) 


