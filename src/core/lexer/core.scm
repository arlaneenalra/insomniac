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

(define <sign-subsequent>
    (or-rule
        <initial>
        <explicit-sign>
        (char-rule #\@)))

(define <dot> (char-rule #\.))

(define <dot-subsequent>
    (or-rule
        <sign-subsequent>
        <dot>))

(define <peculiar-identifier>
    (or-rule
        <explicit-sign>

        (chain-rule
            <explicit-sign>
            <sign-subsequent>
            (*-rule <subsequent>))
        
        (chain-rule
            <explicit-sign>
            <dot>
            <dot-subsequent>
            (*-rule <subsequent>))
        
        (chain-rule
            <dot>
            <dot-subsequent>
            (*-rule <subsequent>))))

(define <identifier>
    (or-rule
        (chain-rule
            <initial> (*-rule <subsequent>))

        (chain-rule
            <vertical-line>
            (*-rule <symbol-element>)
            <vertical-line>)

        <peculiar-identifier>))

;;
;; Booleans
;;

(define <boolean-true>
    (or-rule
        (str-rule "#t")
        (str-rule "#true")))

(define <boolean-false>
    (or-rule
        (str-rule "#f")
        (str-rule "#false")))

;;
;; Characters
;;

(define <character-name>
    (or-rule
        (str-rule "alarm")
        (str-rule "backspace")
        (str-rule "delete")
        (str-rule "escape")
        (str-rule "newline")
        (str-rule "null")
        (str-rule "return")
        (str-rule "space")
        (str-rule "tab")))

(define <character>
    (chain-rule
        (char-rule #\#)
        (char-rule #\\)
        (or-rule
            <character-name>

            (chain-rule
                (char-rule #\x)
                <hex-scalar-value>)

            any-rule)))

;;
;; Strings 
;;

(define <string-element>
    (or-rule
        <inline-hex-escape>
        <mnemomic-escape>

        ;; string escapes
        (chain-rule
            (char-rule #\\)
            (or-rule
                (char-rule #\")
                (char-rule #\\)
                (char-rule #\|)
                (chain-rule
                    (*-rule <intraline-whitespace>)
                    <line-ending>
                    (*-rule <intraline-whitespace>))))

        (not-rule
            (or-rule
                (char-rule #\")
                (char-rule #\\)))))

(define <string>
    (chain-rule
        (char-rule #\")
        (*-rule <string-element>)
        (char-rule #\")))

;; Define the top level lexer
(define scheme-lexer
    (make-lexer
        (bind-token '*comment* <comment>)
        (bind-token '*identifier* <identifier>)

        (bind-token '*boolean-true* <boolean-true>)
        (bind-token '*boolean-false* <boolean-false>)

        (bind-token '*character* <character>)
        (bind-token '*string* <string>)

        (bind-token '*white-space* <whitespace>)))


