;;;
;;; Tests for token streams.
;;;

(include "../src/lib/test/expect.scm")
(include "../src/core/lexer/core.scm")

(define (call-with-stream str proc)
    (call-with-input str
        (lambda () (proc (char-stream 2)))))

(define token-matcher (bind-token 'TOK (char-rule #\A)))

(expect "Verify that a bound token matcher returns a token"
    (call-with-stream "A"
        (lambda (stream)
            (token-matcher stream)))
    (token 'TOK "A"))

(expect "Verify that a bound token matcher returns false on a non-match"
    (call-with-stream "B"
        (lambda (stream)
            (list
                (stream)
                (stream)
                (token-matcher stream))))

    (list
        (eof-object)
        #\B
        #f))

(define lexer
    (or-rule
        (bind-token 'ABC
            (chain-rule
                (char-rule #\A)
                (char-rule #\B)
                (char-rule #\C)))
        (bind-token 'WS (char-rule #\x20))
        (bind-token '*EOF* eof-rule)))

(expect "Verify that we can create a crude lexer"
    (call-with-stream "ABC  ABC"
        (lambda (stream)
            (list
                (lexer stream)
                (lexer stream)
                (lexer stream)
                (lexer stream)
                (lexer stream))))
    (list
        (token '*EOF* (eof-object))
        (token 'ABC "ABC")
        (token 'WS " ")
        (token 'WS " ")
        (token 'ABC "ABC")))
                
