;;;
;;; Tests fo 
;;;

(include "../src/lib/test/expect.scm")

(include "../src/core/lexer/core.scm")

(define (call-with-stream str proc)
    (call-with-input str
        (lambda () (proc (char-stream 2)))))
     

(define match-A (char-rule #\A))

(expect "Verify that a matcher can match a character"
    (call-with-stream "A"
        (lambda (stream)
            (list
                (stream)
                (match-A stream))))
    (list (eof-object) #\A)) 

(expect "Verify that a matcher replaces an unmatched character"
    (call-with-stream "B"
        (lambda (stream)
            (list
                (stream)
                (match-A stream))))
    (list #\B #f))

(define match-ABC
    (chain-rule
        (char-rule #\A)
        (char-rule #\B)
        (char-rule #\C)))

(expect "Verify that a chain rule can match"
    (call-with-stream "ABCD"
        (lambda (stream)
            (list
                (stream)
                (match-ABC stream))))
    (list
        #\D
        (list #\A #\B #\C)))

(expect "Verify that a chain rule can reject in the middle"
    (call-with-stream "ABB"
        (lambda (stream)
            (list
                (stream)
                (stream)
                (stream)
                (stream)
                (match-ABC stream))))

    (list
        (eof-object)
        #\B #\B #\A
        #f))

