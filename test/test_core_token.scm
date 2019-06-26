;;;
;;; Tests for token streams.
;;;

(include "../src/lib/test/expect.scm")
(include "../src/core/lexer/core.scm")

(define (call-with-stream str proc)
    (call-with-input str
        (lambda () (proc (char-stream 2)))))

(define token-matcher (bind-token 'TOK (char-rule #\A)))

(expect "Verify that a bond token matcher returns a token"
    (call-with-stream "A"
        (lambda (stream)
            (token-matcher stream)))
    (token 'TOK "A"))

(expect "Verify that a bond token matcher returns false on a non-match"
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

