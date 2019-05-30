;;;
;;; Some basic string functions
;;;

;; Directly convert a string into a bytevector.
(define (string->u8 str)
    (asm (str) str->slice))

;; Directly convert a byte vector into a string.
(define (u8->string u8)
    (asm (u8) u8->str))

;; Determine the length of a string.
(define (string-length str)
    (bytevector-length (string->u8 str)))

;; Slice a string.
(define (substring str start end)
    (u8->string
        (slice (string->u8 str) start end)))

;; Convert a String into a utf8 
;;(define (utf8->string bytevector . args)
;;    "")

;;(define (string->utf8 string . args)
;;    (bytevector 0))

