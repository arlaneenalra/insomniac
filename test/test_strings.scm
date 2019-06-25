;;;
;;; Test strings
;;;

(include "../lib/test/expect.scm")

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

(expect "string->list should return a list of characters"
    (lambda ()
        (string->list "Hello"))
    (list #\H #\e #\l #\l #\o)) 

(expect "list->string should return a string from a list of characters"
    (lambda ()
        (list->string (list #\B #\y #\e)))
    "Bye")

