;;;
;;; The core of a simple lexical analyzer.
;;;

(include "stream.scm")
(include "matchers.scm")
(include "token.scm")

;;
;; Define scheme matching rules
;;

(define <intraline-whitespace>
    (or-rule
        (char-rule #\x20)
        (char-rule #\x09)))

(define <line-ending>
    (or-rule
        (chain-rule
            (char-rule #\x10)
            (char-rule #\x13))
        (chain-rule
            (char-rule #\x13)
            (char-rule #\x10))
        (char-rule #\x10)
        (char-rule #\x13)))

(define <whitespace>
    (or-rule
        <intraline-whitespace>
        <line-ending>))

;; Define the top level lexer
(define scheme-lexer
    (make-lexer
        (bind-token '*white-space* <whitespace>)))


