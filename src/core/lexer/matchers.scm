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

;; Rule to match a specific character
(define (char-rule ch)
    (rule
        (lambda (stream-ch)
            (eq? stream-ch ch))))

;; Actually walks a list of rules
(define (chain-rule-walker result rule-list stream)
    (if (null? rule-list)
        ;; We've matched all the rules
        (reverse result)

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
                    (for-each stream result)
                    #f)))))

;; Given a list of rules, match all or none and return a list of the matched
;; characters
(define (chain-rule . rule-list)
    (lambda (stream)
        (chain-rule-walker '() rule-list stream)))


