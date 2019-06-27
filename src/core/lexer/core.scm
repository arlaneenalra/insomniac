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
            (char-rule #\x0A)
            (char-rule #\x0D))
        (chain-rule
            (char-rule #\x0D)
            (char-rule #\x0A))
        (char-rule #\x0A)
        (char-rule #\x0D)))

(define <whitespace>
    (or-rule
        <intraline-whitespace>
        <line-ending>))

(define <comment>
    (or-rule
        (chain-rule
            (char-rule #\;)
            (*-rule
                (not-rule <line-ending>)))

                ))

;; Define the top level lexer
(define scheme-lexer
    (make-lexer
        (bind-token '*comment* <comment>)
        (bind-token '*white-space* <whitespace>)))


