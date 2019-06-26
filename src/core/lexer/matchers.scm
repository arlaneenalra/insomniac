;;;
;;; Matching library used to match charater sequences.
;;;

;; Define a matcher that either returns the matched character or #f
;; based on the given rule. 
(define (rule predicate)
    (lambda (stream)
        (define ch (stream))

        (if (predicate ch)
            ch
            (begin
                (stream ch)
                #f))))

;; Put the result back into the correct order
(define (normalize-chain result)
    (flatten (reverse result)))

;; Actually walks a chain of rules
(define (chain-rule-walker result rule-list stream)
    (if (null? rule-list)
        ;; We've matched all the rules
        (normalize-chain result)

        ;; We're not there yet, walk to the next rule.
        (begin
            (define rule (car rule-list))
            (define ch (rule stream))
          
            ;; Check if we've matched
            (if ch
                ;; Walk to next character
                (chain-rule-walker
                    (cons ch result)
                    (cdr rule-list)
                    stream)

                ;; Rest and return false
                (begin
                    ;; Put things in the correct order
                    ;; to reset the stream
                    (for-each stream 
                        (reverse (normalize-chain result)))
                    #f)))))

;; Given a list of rules, match all or none and return a list of the matched
;; characters
(define (chain-rule . rule-list)
    (lambda (stream)
        (chain-rule-walker '() rule-list stream)))

;; Given a list of rules, match only one rule and return it's result.
(define (or-rule . rule-list)
    (lambda (stream)
        (define (walker rule-list)
            (if (null? rule-list)
                #f
                (begin
                    (define rule (car rule-list))
                    (define ch (rule stream))
                    (if ch
                        ch
                        (walker (cdr rule-list))))))
        (walker rule-list)))

;; Given a rule attempt to match it and keep building a result
;; until the rule does not match.
(define (*-rule-walker result rule stream)
    (define ch (rule stream))
    (if ch
        (*-rule-walker (cons ch result) rule stream)
        (normalize-chain result)))
    
;; Wraps a rule allowing it to match list a none or more instances
(define (*-rule rule)
    (lambda (stream)
        (*-rule-walker '() rule stream))) 

;;;
;;; Specific matching rules
;;;

;; Rule to match a specific character
(define (char-rule ch)
    (rule
        (lambda (stream-ch)
            (eq? stream-ch ch))))

;; Rule that matches a range of characters
(define (range-rule start end)
    (rule
        (lambda (stream-ch)
            (and (char>=? stream-ch start)
                (char<=? stream-ch end)))))

;; Rule to mathc end of file
(define eof-rule
    (rule
        (lambda (obj)
            (eof-object? obj))))

