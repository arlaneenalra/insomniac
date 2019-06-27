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

(define <vertical-line> (char-rule #\|))

(define <delimiter>
    (or-rule
        <whitespace>
        <vertical-line>
        (char-rule #\()
        (char-rule #\))
        (char-rule #\")
        (char-rule #\;)))

(define <directive>
    (or-rule
        (str-rule "#!fold-case")
        (str-rule "#!no-fold-case")))

(define <atmosphere>
    (or-rule
        <whitespace>
        (lambda (stream) (<comment> stream))
        <directive>
        ))

(define <intertoken-space>
    (*-rule <atmosphere>))

;;
;; Comment handling
;;
(define <nested-comment-start> (str-rule "#|"))
(define <nested-comment-end> (str-rule "|#"))

(define <comment-text>
    (+-rule
        (not-rule
            (or-rule
                <nested-comment-start>
                <nested-comment-end>))))

(define <nested-comment>
    (chain-rule
        <nested-comment-start>
     ;;   <comment-text>

        ;; <comment-cont>
        (*-rule 
            (or-rule
                ;; Reference to the rule before it's defined
                (lambda (stream) (<nested-comment> stream))
                <comment-text>))
        <nested-comment-end>))

(define <comment>
    (or-rule
        ;; Single line comment 
        (chain-rule
            (char-rule #\;)
            (*-rule
                (not-rule <line-ending>)))
        <nested-comment>

        (chain-rule
            (str-rule "#;")
            <intertoken-space>
            ;; MISSING <datum>
            )
        ))

;;
;; Identifiers
;;

; NOTE: This may need to be adjusted for unicode handling.
(define <letter>
    (or-rule
        (range-rule #\A #\Z)
        (range-rule #\a #\z)))

(define <explicit-sign> (set-rule "+-"))

(define <digit> (range-rule #\0 #\9))

(define <hex-digit>
    (or-rule
        (range-rule #\a #\f)
        <digit>))

(define <hex-scalar-value> (+-rule <hex-digit>))

(define <inline-hex-escape>
    (chain-rule
        (str-rule "\x")
        <hex-scalar-value>))

(define <mnemomic-escape>
    (chain-rule
        (char-rule #\\)
        (set-rule "abtnr")))

(define <symbol-element>
    (or-rule
        (not-rule (set-rule "\\|"))
        <inline-hex-escape>
        <mnemomic-escape>
        (str-rule "\|")))

(define <special-initial> (set-rule "!$%&*/:<=>?@^_~"))

(define <initial>
    (or-rule
        <letter>
        <special-initial>))
        
(define <special-subsequent>
    (or-rule
        (set-rule ".@")
        <explicit-sign>))

(define <subsequent>
    (or-rule
        <initial>
        <digit>
        <special-subsequent>))


(define <identifier>
    (or-rule
        (chain-rule
            <initial> (*-rule <subsequent>))

        (chain-rule
            <vertical-line>
            (*-rule <symbol-element>)
            <vertical-line>)
))

;; Define the top level lexer
(define scheme-lexer
    (make-lexer
        (bind-token '*comment* <comment>)
        (bind-token '*identifier* <identifier>)
        (bind-token '*white-space* <whitespace>)))


