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

