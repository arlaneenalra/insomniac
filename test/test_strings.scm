;;;
;;; Test strings
;;;

(include "expect.scm")

(expect "Converting a bytevector into a string works"
    (lambda ()
        (u8->string (bytevector 65 66 67 68 69 70)))

    "ABCDEF")

(expect "Converting a string into a bytevector works"
    (lambda ()
        (string->u8 "ABCDEF"))
       
    (bytevector 65 66 67 68 69 70))

(expect "Converting a number into a character works"
    (lambda ()
        (integer->char 65))
    #\A)

(expect "Converting a character into a number works"
    (lambda ()
        (char->integer #\a))
    97)
        
