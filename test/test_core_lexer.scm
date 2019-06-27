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

