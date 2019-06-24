;;;
;;; Entry point for the Insomniac Compiler
;;;


;; Configuration Options for Compiler
(define-record-type :insc-config
    (make-insc-config name source output)
    insc-config?
    (name insc-config-name)
    (source insc-config-source insc-config-source-set!)
    (output insc-config-output insc-config-output-set!))


;; Very crude command line argument processor
(define (build-config cmd-line)
    (let*
        ((name (car cmd-line))
         (args (cdr cmd-line))
         (config (make-insc-config name "" "a.out"))
         (usage (lambda ()
            (display name)
            (display " <source>")
            (exit 1)))

         (walker (lambda (config cmd-line)
                    (cond
                        ((null? cmd-line) config)
                        ((not (eq? "" (car cmd-line)))
                            (insc-config-source-set! config (car cmd-line))
                            (walker config (cdr cmd-line)))
                        (else (usage))))))


        (if (eq? 0 (length args))
            (usage)
            (walker config args))))

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
            
(define (lexer next-char)
    (define c
        (next-char))

    (if (eof-object? c)
        #t
        (begin
            (display c)
            (lexer next-char))))


(let*
    ((config (build-config (command-line))))
    
    (display "Compiling: ")
    (display (insc-config-source config))

    (with-input-from-file
        (insc-config-source config)
        (lambda ()
            (lexer (char-stream)))))

