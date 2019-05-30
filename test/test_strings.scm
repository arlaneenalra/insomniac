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


