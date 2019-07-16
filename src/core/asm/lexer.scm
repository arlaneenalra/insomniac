;;;
;;; A lexer for the internal Insomniac scheme compiler.
;;;

(include "../lexer/core.scm")

(define <comment>
    (chain-rule
        (char-rule #\;)
        (*-rule (not-rule <line-ending>))
        <line-ending>))

(define <digits> (+-rule (range-rule #\0 #\9)))

(define <fixnum-literal>
    (chain-rule
        (?-rule (set-rule "+-"))
        <digits>))

(define <letter>
    (or-rule
        (range-rule #\A #\Z)
        (range-rule #\a #\z)))

(define <ident>
    (or-rule
        (set-rule "!$%&*+\-./<=>?@^_~")
        <letter>
        <digits>))

(define <target> (+-rule <ident>))

(define <label>
    (chain-rule
        <target>
        (char-rule #\:)))

(define <character>
    (chain-rule
        (char-rule #\#)
        (char-rule #\\)
        (or-rule
            (str-rule "newline")
            (str-rule "space")
            (str-rule "eof")
            (not-rule <whitespace>))))

(define <string>
    (chain-rule
        (char-rule #\")
        (*-rule
            (or-rule
                ;; escapes
                (chain-rule 
                    (char-rule #\\)
                    (or-rule
                        (char-rule #\")
                        (char-rule #\\)))
                (not-rule
                    (or-rule
                        (char-rule #\")
                        (char-rule #\\)))))
        (char-rule #\")))

(define <symbol>
    (chain-rule
        (char-rule #\s)
        <string>))

;; Matcher for instructions that require a target
(define (target-op op)
    (chain-rule
        (str-rule op)
        <whitespace>
        <target>))
        
        

(define asm-lexer
    (filter-token-stream
        (make-lexer
            (bind-token '*white-space* <whitespace>)
            (bind-token '*comment* <comment>)
            
            ;; Literals
            (bind-token '*fixnum-literal* <fixnum-literal>)
            (bind-token '*true-literal* (str-rule "#t"))
            (bind-token '*false-literal* (str-rule "#f"))
            (bind-token '*empty-literal* (str-rule "()"))
            
            (bind-token '*is-fixnum*  (str-rule "fixnum?"))
            (bind-token '*is-bool*  (str-rule "bool?"))
            (bind-token '*is-char*  (str-rule "char?"))
            (bind-token '*is-symbol*  (str-rule "symbol?"))
            (bind-token '*is-vector*  (str-rule "vector?"))
            (bind-token '*is-byte-vector*  (str-rule "vector-u8?"))
            (bind-token '*is-pair*  (str-rule "pair?"))
            (bind-token '*is-empty*  (str-rule "null?"))
            (bind-token '*is-closure*  (str-rule "proc?"))
            (bind-token '*is-self*  (str-rule "self?"))

            (bind-token '*make-vector*  (str-rule "vector"))
            (bind-token '*make-byte-vector*  (str-rule "vector-u8"))
            (bind-token '*make-record*  (str-rule "record"))
            (bind-token '*index-ref*  (str-rule "idx@"))
            (bind-token '*index-set*  (str-rule "idx!"))

            (bind-token '*vector-length*  (str-rule "vec-len"))
            (bind-token '*string-byte-vector*  (str-rule "str->u8"))
            (bind-token '*byte-vector-string*  (str-rule "u8->str"))
            (bind-token '*int-to-char*  (str-rule "int->char"))
            (bind-token '*char-to-int*  (str-rule "char->int"))
           

            (bind-token '*output* (str-rule "out"))
            (bind-token '*fd-read* (str-rule "read"))
            (bind-token '*fd-write* (str-rule "write"))
            (bind-token '*open* (str-rule "open"))
            (bind-token '*close* (str-rule "close"))
            (bind-token '*slurp* (str-rule "slurp"))
            (bind-token '*asm* (str-rule "asm"))
            (bind-token '*import* (str-rule "import"))

            (bind-token '*nop* (str-rule "nop"))
            (bind-token '*dup-ref* (str-rule "dup"))
            (bind-token '*depth* (str-rule "depth"))
            (bind-token '*drop* (str-rule "drop"))
            (bind-token '*swap* (str-rule "swap"))
            (bind-token '*rot* (str-rule "rot"))
            (bind-token '*make-symbol* (str-rule "sym"))
            
            (bind-token '*cons* (str-rule "cons"))
            (bind-token '*car* (str-rule "car"))
            (bind-token '*cdr* (str-rule "cdr"))
            (bind-token '*set-car* (str-rule "set-car"))
            (bind-token '*set-cdr* (str-rule "set-cdr"))

            (bind-token '*bind* (str-rule "bind"))
            (bind-token '*set*  (char-rule #\!)) 
            (bind-token '*read* (char-rule #\@)) 
           
            (bind-token '*add* (char-rule #\+)) 
            (bind-token '*sub* (char-rule #\-)) 
            (bind-token '*mul* (char-rule #\*)) 
            (bind-token '*div* (char-rule #\/)) 
            (bind-token '*mod* (char-rule #\%)) 
            
            (bind-token '*numeric-equal* (char-rule #\=)) 
            (bind-token '*numeric-lt* (char-rule #\<)) 
            (bind-token '*numeric-gt* (char-rule #\>)) 

            (bind-token '*eq* (str-rule "eq"))
            (bind-token '*not* (str-rule "not"))
            
            (bind-token '*throw* (str-rule "throw"))
            (bind-token '*restore* (str-rule "restore"))
            (bind-token '*set-exit* (str-rule "set-exit"))
    
            (bind-token '*adopt* (str-rule "adopt"))

            (bind-token '*proc* (target-op "proc"))
            (bind-token '*call* (target-op "call"))
            (bind-token '*continue* (target-op "continue"))
            (bind-token '*jnf* (target-op "jnf"))
            (bind-token '*jmp* (target-op "jmp"))

            (bind-token '*gc-stats* (str-rule "gc-stats"))
            (bind-token '*directive-file* (str-rule ".file"))
            
            (bind-token '*jin* (str-rule "jin"))
            (bind-token '*ret* (str-rule "ret"))
            (bind-token '*call-in* (str-rule "call_in"))
            (bind-token '*tail-call-in* (str-rule "tail_call_in"))
            (bind-token '*call-ext* (str-rule "call_ext"))

            (bind-token '*label* <label>)
            (bind-token '*char-literal* <character>)
            (bind-token '*string-literal* <string>)
            (bind-token '*symbol-literal* <symbol>))

         
        (lambda (token)
            (eq? (token-type token) '*white-space*))))


