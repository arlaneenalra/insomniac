;;;
;;; Some basic emitter functions to help output formatted code.
;;;

;; Some code for handling labeled constants
(define (write-labeled-list directive *list*)
    (define (walker list)
        (if (null? list)
            #t
            (let*
                ((entry (car list))
                 (label (cdr entry))
                 (str (car entry)))
               
                (write-string label)
                (write-string ": ")

                (write-directive directive str)
                (walker (cdr list)))))
    (walker *list*))

(define *newline* (list->string '(#\newline)))

(define (emit-indent) (write-string "    "))

(define (escape str)
    (define (walker res list)
        (cond
            ((null? list)
                (list->string (reverse res)))
            ((eq? #\\ (car list))
                (walker res (cdr list)))
            (else
                (walker
                    (cons (car list) res)
                    (cdr list)))))
    (walker '() (string->list str)))

;; Emit the operand list of an op
(define (write-operand . operand-list)
    (cond
        ((null? operand-list)
            #t)
        ((null? (cdr operand-list))
                (write-string (escape (car operand-list))))
        (else
            (begin
                (write-string (escape (car operand-list)))
                (write-string ", ")
                (apply write-operand (cdr operand-list))))))
        

;; Emit an op and operands
(define (write-op op-code . operand-list)
    (emit-indent)
    (write-string op-code)
    (write-string "   ")
    (apply write-operand operand-list)
    (write-string *newline*))

;; Emit directive
(define (write-directive directive . operand-list)
    (write-string ".")
    (write-string directive)
    (write-string "   ")
    (apply write-operand operand-list)
    (write-string *newline*))

;; Emit a comment
(define (write-comment text)
    (write-string "# ")
    (write-string text)
    (write-string *newline*))

;; Setup jump operations
(define (make-jump-op op)
    (lambda (target token)
        (let*
            ((token-content (token-text token))
             (label (car (cdr (cdr token-content)))))

            (write-op op (token-text label)))))

(define emit-call (make-jump-op "callq"))
(define emit-jmp (make-jump-op "jmp"))

;; Emit a label
(define (emit-label target token)
    (write-string
        (string-append
            (token-text (car (token-text token)))
            ":"
            *newline*)))


;; Handler code for strings
(define *string-list* '())

;; Emit a string-literal
(define (emit-string target token)
    (define scratch (target-scratch-register target))
    (define str 
        (string-append "\"" (token-text (car (cdr (token-text token)))) "\""))
    (define label (assq str *string-list*))

    (define found-label
        (if (not label)
            (begin
                (set! label ((target-labeler target)))
                (set! *string-list*
                    (cons
                        (cons str label)
                        *string-list*))
                label)
            (cdr label)))

    (write-comment "-- string literal - start")

    (write-op "leaq"
        (string-append found-label "(%rip)")
        (scratch 0))
    (write-op "pushq" (scratch 0))
    
    (write-comment "-- string literal - end"))


;; Emit all strings
(define (emit-string-list)
    (write-labeled-list "string" *string-list*))

;; Handler code for fixnums
(define *fixnum-list* '())

(define (emit-fixnum target token)
    (define fixnum (token-text token))
    (define label (assq fixnum *fixnum-list*))

    (define found-label
        (if (not label)
            (begin
                (set! label ((target-labeler target)))
                (set! *fixnum-list*
                    (cons
                        (cons fixnum label)
                        *fixnum-list*))
                label)
            (cdr label)))

    (write-op "pushq" (string-append found-label "(%rip)")))

(define (emit-fixnum-list) 
    (write-labeled-list "quad" *fixnum-list*))


;;
;; Basic IO operations
;;

(define (emit-write target token)
    (define abi-reg (target-abi-register target))

    (write-comment "-- fd-write - start")

    (write-op "popq" (abi-reg 0))
    (write-op "popq" (abi-reg 2))
    (write-op "popq" (abi-reg 1))
    (write-op "call" "_write")
    (write-op "pushq" (abi-reg '*ret*))

    (write-comment "-- fd-write - end"))

(define (emit-drop target token)
    (define abi-reg (target-abi-register target))

    (write-comment "-- drop - start")

    (write-op "popq" (abi-reg '*ret*))

    (write-comment "-- drop - end"))


