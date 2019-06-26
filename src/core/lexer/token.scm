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

