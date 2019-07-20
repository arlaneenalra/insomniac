;;;
;;; Some basic string functions
;;;

;; Directly convert a string into a bytevector.
(define (string->u8 str)
    (asm (str) str->u8))

;; Directly convert a byte vector into a string.
(define (u8->string u8)
    (asm (u8) u8->str))

;; Determine the length of a string.
(define (string-length str)
    (bytevector-length (string->u8 str)))

;; Slice a string.
(define (substring str start end)
    (u8->string
        (bytevector-copy (string->u8 str) start end)))

;; Convert a String into a utf8 
;;(define (utf8->string bytevector . args)
;;    "")

;;(define (string->utf8 string . args)
;;    (bytevector 0))

(define (string->list str)
    (let*
        ((u8-list (u8->list (string->u8 str))))
        
        (map integer->char u8-list)))

(define (list->string list)
    (u8->string
        (list->u8 
            (map char->integer list))))

(define (string-append . str-list)
    (define (appender str str-list)
        (if (null? str-list)
            str
            (appender
                (append str (string->list (car str-list)))
                (cdr str-list))))
    (list->string
        (appender '() str-list)))

;; Convert a number into a string
(define (number->string num)
    (define zero (char->integer #\0))
    (define negative (if (> 0 num) #t #f))

    (if negative
        (set! num (* -1 num)))

    (define (walker digit-list num)
        (define digit (+ zero (% num 10)))

        (if (> num 0)
            (walker
                (cons digit digit-list)
                (/ num 10))
            (let*
                ((char-list (map integer->char digit-list)))
                (list->string 
                    (if negative
                        (cons #\- char-list)
                        char-list)))))

    (if (eq? num 0)
        "0"
        (walker '() num)))

;;
;; Some basic Character maninuplation functions
;;

(define (integer->char num)
    (asm (num) int->char))

(define (char->integer char)
    (asm (char) char->int))

;;
;; Character predicates
;;

(define (char=? a . args)
    (cond
        ((null? args) #t)
        ((not  
            (= (char->integer a) 
                (char->integer (car args))))
                #f)
        (else
            (apply char=? args))))

(define (char<? a . args)
    (cond
        ((null? args) #t)
        ((not  
            (< (char->integer a) 
                (char->integer (car args))))
                #f)
        (else
            (apply char<? args))))

(define (char<=? a . args)
    (cond
        ((null? args) #t)
        ((not  
            (<= (char->integer a) 
                (char->integer (car args))))
                #f)
        (else
            (apply char<=? args))))

(define (char>? a . args)
    (cond
        ((null? args) #t)
        ((not  
            (> (char->integer a) 
                (char->integer (car args))))
                #f)
        (else
            (apply char>? args))))

(define (char>=? a . args)
    (cond
        ((null? args) #t)
        ((not  
            (>= (char->integer a) 
                (char->integer (car args))))
                #f)
        (else
            (apply char>=? args))))
     
