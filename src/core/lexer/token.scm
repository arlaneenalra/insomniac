;;;
;;; Define a simple tokenizer and token stream.
;;;

;; Combinds any list of characters that can be into a String
(define (merge-strings match)
    (define (make-str result next-str)
        (if (null? next-str)
            result
            (cons (list->string (reverse next-str)) result)))

    (define (walker result next-str match)
        (cond
            ((null? match)
                (begin
                    (define output (make-str result next-str)))
                    (if (= 1 (length output))
                        (car output)
                        (reverse output)))
            ((char? (car match))
                (walker
                    result
                    (cons (car match) next-str)
                    (cdr match)))
            ((token? (car match))
                (begin
                    (walker
                        (cons
                            (car match)
                            (make-str result next-str))
                        '()
                        (cdr match))))
            (else
                (raise "Unexpected item in match!" match))))
    (walker '() '() match))
                    

;; Binds a matcher rule to an action
(define (bind-token type rule)
    (lambda (stream)
        (define match (rule stream))
       
        (if match
            (token type
                (if (eof-object? match)
                    match
                    (merge-strings (flatten match))))
;                    (list->string (flatten match))))
            #f)))


;; Creates a very simple lexer with default handling for EOF
;; and unmatched tokens
(define (make-lexer . rule-list)
    (or-rule
        (apply or-rule rule-list)

        (bind-token '*EOF* eof-rule)
        (bind-token '*UNMATCHED* any-rule)))

;; A simple filtering wrapper arond a token stream.
;; if the rule returns true, the token is dropped.
(define (filter-token-stream lexer rule)
    (define (filter stream)
        (define token (lexer stream))

        (if (rule token)
            (filter stream)
            token))
    filter)


;; Define a couple of token rules
(define (token-rule token)
    (rule
        (lambda (in-token)
            (eq?
                (token-type in-token)
                (token-type token)))))

