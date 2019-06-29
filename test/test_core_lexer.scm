;;;
;;; Tests for some of the more ornerous tokens
;;;

(include "../src/lib/test/expect.scm")
(include "../src/core/lexer/core.scm")

(define (call-with-stream str proc)
    (call-with-input str
        (lambda () (proc (char-stream 2)))))
 
(expect "Verify that nested comments work"
    (call-with-stream "#|abcefg|# 123"
            <nested-comment>)
    (string->list "#|abcefg|#"))

(expect "Verify that empty nested comments work"
    (call-with-stream "#||# 123"
            <nested-comment>)
    (string->list "#||#"))

(expect "Verify that nested nested comments work"
    (call-with-stream "#|#||#|# 123"
            <nested-comment>)
    (string->list "#|#||#|#"))

(expect "Verify that nested comments with other text work"
    (call-with-stream "#|ab#||#fg|# 123"
            <nested-comment>)
    (string->list "#|ab#||#fg|#"))

(expect "Verify that nested comments with other text work"
    (call-with-stream "#|ab#|asdf|# #|boo|#|# 123"
            <nested-comment>)
    (string->list "#|ab#|asdf|# #|boo|#|#"))

(expect "Verify that complex comments work" 
    (call-with-stream "#|ab#|asdf|# #|boo|#|# 123"
            <comment>)
    (string->list "#|ab#|asdf|# #|boo|#|#"))

(expect "Verify that complex comments work" 
    (call-with-stream "#|ab#|asdf|# #|boo|#|# 123"
            <atmosphere>)
    (string->list "#|ab#|asdf|# #|boo|#|#"))

(expect "Verify that identifier matches empty || style identifiers"
    (call-with-stream "|| 123"
        <identifier>)
    (string->list "||"))

(expect "Verify that identifier matches || style identifiers"
    (call-with-stream "|abc| 123"
        <identifier>)
    (string->list "|abc|"))

(expect "Verify that identifier matches || style identifiers with mnemomic escape"
    (call-with-stream "|a\bc| 123"
        <identifier>)
    (string->list "|a\bc|"))

(expect "Verify that identifier matches || style identifiers with escapes"
    (call-with-stream "|a\|c| 123"
        <identifier>)
    (string->list "|a\|c|"))

(expect "Verify that identifier matches || style identifiers with escapes"
    (call-with-stream "|a\x0ac| 123"
        <identifier>)
    (string->list "|a\x0ac|"))

(expect "Verify that a base 2 raidx is matchable"
    (call-with-stream "#b100" <radix-2>)
    (string->list "#b"))

(expect "Verify that a base 10 raidx is matchable"
    (call-with-stream "100" <radix-10>)
    '())

(expect "Verify that an explicit base 10 raidx is matchable"
    (call-with-stream "#d100" <radix-10>)
    (string->list "#d"))

(expect "Verify that an explicit base 10 raidx is matchable"
    (call-with-stream "100" (or-rule <radix-10> <exactness>))
    '())

(expect "Verify that a base ten number matches"
    (call-with-stream "1234567890" <num-10>) 
    (string->list "1234567890"))

(expect "Verify that a base ten number matches"
    (call-with-stream "#i#d1234567890" <num-10>) 
    (string->list "#i#d1234567890"))

(expect "Verify that a base ten number matches"
    (call-with-stream "#d#i1234567890" <num-10>) 
    (string->list "#d#i1234567890"))

(expect "Verify that a base ten fraction matches"
    (call-with-stream "12345/67890" <num-10>) 
    (string->list "12345/67890"))

(expect "Verify a complex number"
    (call-with-stream "-10+50i" <num-10>) 
    (string->list "-10+50i"))

(expect "Verify a bytevector"
    (call-with-stream "#u8( 1 30 45)" 
        (lambda (stream)
            (reverse 
                (list 
                    (scheme-lexer stream)
                    (scheme-lexer stream)
                    (scheme-lexer stream)
                    (scheme-lexer stream)
                    (scheme-lexer stream)))))
    (list
        (token '*bytevector-start* "#u8(")
        (token '*number* "1")
        (token '*number* "30")
        (token '*number* "45")
        (token '*close-paren* ")"))) 

