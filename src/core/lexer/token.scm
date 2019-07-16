;;;
;;; Define a simple tokenizer and token stream.
;;;

;; Defines a token type that can be returned by the lexer 
(define-record-type <token>
    (token type text)
    token?
    (type token-type)
    (text token-text))

;; Binds a matcher rule to an action
(define (bind-token type rule)
    (lambda (stream)
        (define match (rule stream))
       
        (if match
            (token type
                (if (eof-object? match)
                    match
                    (list->string (flatten match))))
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

