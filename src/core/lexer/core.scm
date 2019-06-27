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
;;
;; Comment handling
;;
(define <nested-comment-start>
    (chain-rule
        (char-rule #\#)
        (char-rule #\|)))

(define <nested-comment-end>
    (chain-rule
        (char-rule #\|)
        (char-rule #\#)))

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
        <nested-comment>))
        

;; Define the top level lexer
(define scheme-lexer
    (make-lexer
        (bind-token '*comment* <comment>)
        (bind-token '*white-space* <whitespace>)))


