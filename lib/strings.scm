;;;
;;; Some basic string functions
;;;

;; Directly convert a string into a bytevector
(define (string->u8 str)
    (asm (str) str->slice))


;; Convert a String into a utf8 
(define (utf8->string bytevector . args)
    "")

(define (string->utf8 string . args)
    (bytevector 0))

