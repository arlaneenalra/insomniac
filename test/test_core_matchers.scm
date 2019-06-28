;;;
;;; Tests for matchers. 
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

(define match-OR-ABC
    (or-rule
        (char-rule #\A)
        (char-rule #\B)
        (char-rule #\C)))

(expect "Verify than an or-rule will only match once"
    (call-with-stream "B"
        (lambda (stream)
            (list
                (stream)
                (match-OR-ABC stream))))
    (list
        (eof-object)
        #\B))

(expect "Verify than an or-rule will only match its child rules"
    (call-with-stream "D"
        (lambda (stream)
            (list
                (stream)
                (stream)
                (match-OR-ABC stream))))
    (list
        (eof-object)
        #\D
        #f))

(define match-ABC-ABC-OR-ABC
    (chain-rule
        match-ABC
        match-ABC
        match-OR-ABC))

(expect "Verify that a more complex rule can be matched"
    (call-with-stream "ABCABCBD" 
        (lambda (stream)
            (list
                (stream)
                (match-ABC-ABC-OR-ABC stream))))
    (list
        #\D
        (list #\A #\B #\C #\A #\B #\C #\B)))

(expect "Verify that a more complex rule can reset" 
    (call-with-stream "ABCABCDD" 
        (lambda (stream)
            (list
                (stream)
                (stream)
                (match-ABC stream)
                (match-ABC stream)
                (match-ABC-ABC-OR-ABC stream))))
    (list
        #\D
        #\D
        (list #\A #\B #\C)
        (list #\A #\B #\C)
        #f))

(define range-BCD (range-rule #\B #\D))

(expect "Verify that a range rule can match characters in a range"
    (call-with-stream "ABCDE"
        (lambda (stream)
            (list
                (stream)
                (range-BCD stream)
                (range-BCD stream)
                (range-BCD stream)
                (range-BCD stream)
                (stream)
                (range-BCD stream))))
    (list #\E #f #\D #\C #\B #\A #f))

(define many-A (*-rule match-A))

(expect "Verify that a * rule can match no characters"
    (call-with-stream "" many-A)
    '())

(expect "Verify that a * rule can match a character"
    (call-with-stream "A" many-A)
    (list #\A))

(expect "Verify that a * rule only matches the correct character"
    (call-with-stream "AAAABA" many-A)
    (list #\A #\A #\A #\A))

(define not-ABC (not-rule match-ABC))

(expect "Verify that a not rule will match a short character"
    (call-with-stream "D" not-ABC)
    #\D)

(expect "Verify that a not rule will not match a character matching the rule"
    (call-with-stream "ABC" not-ABC)
    #f)

(expect "Verify that a not rule will match something that doesn't match its rule"
    (call-with-stream "AAAABC"
        (lambda (stream)
            (list
                (stream)
                (rest-rule stream)
                ((*-rule not-ABC) stream))))
    (list
        (eof-object)
        (list #\A #\B #\C)
        (list #\A #\A #\A)))

(define str-ABC (str-rule "ABC"))

(expect "Verify that a str-rule matches a string"
    (call-with-stream "ABC"
        str-ABC)
    (string->list "ABC"))

(define opt-A-B
    (chain-rule
        (?-rule (char-rule #\A))
        (char-rule #\B)))

(expect "verify that ?-rule can match"
    (call-with-stream "ABC" opt-A-B)
    (string->list "AB"))

(expect "verify that ?-rule can match"
    (call-with-stream "BC" opt-A-B)
    (string->list "B"))

(expect "verify that ?-rule can not match"
    (call-with-stream "AABC" opt-A-B)
    #f) 

