;;;
;;; The core of a simple lexical analyzer.
;;;

(include "stream.scm")
(include "matchers.scm")
(include "token.scm")
(include "lexer.scm")

                
;(define <bytevector>
;    (chain-rule <whitespace>
;        <bytevector-start>
;        (*-rule <byte>)
;        <close-paren>)) 
 

;; TODO start putting together the parser
