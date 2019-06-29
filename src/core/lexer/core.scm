;;;
;;; The core of a simple lexical analyzer.
;;;

(include "stream.scm")
(include "matchers.scm")
(include "token.scm")

;;
;; Define scheme matching rules
;;

(define <open-paren> (char-rule #\())
(define <close-paren> (char-rule #\)))

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
    (+-rule 
        (or-rule
            <intraline-whitespace>
            <line-ending>)))

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
        (range-rule #\A #\F)
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


;;
;; Numbers
;;

(define <plus-minus> (set-rule "+-"))
(define <sign> (?-rule <plus-minus>))

(define <exponent-marker> (set-rule "eE"))
(define <exactness>
    (?-rule
        (chain-rule
            (char-rule #\#)
            (set-rule "iIeE"))))

(define <radix-2>
    (chain-rule
        (char-rule #\#)
        (set-rule "bB")))
        
(define <radix-8>
    (chain-rule
        (char-rule #\#)
        (set-rule "oO")))

(define <radix-10>
    (?-rule
        (chain-rule
            (char-rule #\#)
            (set-rule "dD"))))

(define <radix-16>
    (chain-rule
        (char-rule #\#)
        (set-rule "xX")))

(define <digit-2> (set-rule "01"))
(define <digit-8> (range-rule #\0 #\7))
(define <digit-10> <digit>)
(define <digit-16> <hex-digit>)

(define <suffix>
    (?-rule
        (chain-rule
            <exponent-marker>
            <sign>
            (+-rule <digit-10>))))

(define <infnan>
    (chain-rule
        <sign>
        (or-rule
            (chain-rule
                (set-rule "iI")
                (set-rule "nN")
                (set-rule "fF"))
            (chain-rule
                (set-rule "nN")
                (set-rule "aA")
                (set-rule "nN")))
        (str-rule ".0")))

(define <i> (set-rule "iI"))

(define <plus-minus-i>
    (chain-rule <plus-minus> <i>))

(define <complex-infnan>
    (chain-rule <infnan> <i>))

;; Numbers are complex on their own.
(define (make-numbers has-decimal digit> <radix>)
    (define <radix-exactness>
        (or-rule <radix> <exactness>))

    (define <prefix>
        (chain-rule <radix-exactness> <radix-exactness>))

    (define <uinteger> (+-rule <digit>))
   
    (define <decimal>
        (if has-decimal
            (or-rule
                (chain-rule <uinteger> <suffix>)
                (chain-rule <dot> (+-rule <digit>) <suffix>)
                (chain-rule (+-rule <digit>) <dot> (*-rule <digit>) <suffix>))

            ;; This radix does not have decimals 
            (lambda (stream) #f))) 

    (define <ureal>
        (or-rule
            (chain-rule <uinteger> (char-rule #\/) <uinteger>)
            <uinteger>
            <decimal>))

    (define <real>
        (or-rule
            (chain-rule <sign> <ureal>)
            <infnan>))

    (define <complex-suffix>
        (or-rule
            (chain-rule <plus-minus> <ureal> <i>)
            <plus-minus-i>
            <complex-infnan>))
  
    (define <complex>
        (or-rule
            (chain-rule <real>
                (?-rule
                    (or-rule
                        (chain-rule (char-rule #\@) <real>)
                        <complex-suffix>)))
            <complex-suffix>))

    (define <num>
        (chain-rule <prefix> <complex>))

    <num>)

(define <num-2> (make-numbers #f <digit-2> <radix-2>))
(define <num-8> (make-numbers #f <digit-8> <radix-8>))
(define <num-10> (make-numbers #t <digit-10> <radix-10>))
(define <num-16> (make-numbers #f <digit-16> <radix-16>))

(define <number>
    (or-rule <num-10> <num-2> <num-8> <num-16>))

;;
;; Byvectors
;; 
(define <bytevector-start> (str-rule "#u8("))

;(define <bytevector>
;    (chain-rule <whitespace>
;        <bytevector-start>
;        (*-rule <byte>)
;        <close-paren>)) 
  
;; Define the top level lexer
(define scheme-lexer
    (filter-token-stream
        (make-lexer
            (bind-token '*comment* <comment>)
            (bind-token '*identifier* <identifier>)

            (bind-token '*boolean-true* <boolean-true>)
            (bind-token '*boolean-false* <boolean-false>)
            
            (bind-token '*number* <number>)

            (bind-token '*open-paren* <open-paren>)
            (bind-token '*close-paren* <close-paren>)

            (bind-token '*bytevector-start* <bytevector-start>)

            (bind-token '*character* <character>)
            (bind-token '*string* <string>)

            (bind-token '*white-space* <whitespace>))

        (lambda (token)
            (eq? (token-type token) '*white-space*))))
                


