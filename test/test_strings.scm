;;;
;;; Test strings
;;;

(include "../src/lib/test/expect.scm")

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

;;
;; char=?
;;

(expect-true "char=? should return true for one character"
    (lambda ()
        (char=? #\A)))

(expect-true "char=? should return true for two characters"
    (lambda ()
        (char=? #\A #\A)))

(expect-true "char=? should return true for more characters"
    (lambda ()
        (char=? #\A #\A #\A #\A #\A)))

(expect-false "char=? should return false for unmatched characters"
    (lambda ()
        (char=? #\A #\B)))

(expect-false "char=? should return false for unmatched characters"
    (lambda ()
        (char=? #\A #\A #\A #\B #\A 'NON-CHAR)))
;;
;; char<?
;;

(expect-true "char<? should return true for one character"
    (lambda ()
        (char<? #\A)))

(expect-true "char<? should return true for two characters"
    (lambda ()
        (char<? #\A #\B)))

(expect-true "char<? should return true for more characters"
    (lambda ()
        (char<? #\A #\B #\C #\D #\E)))

(expect-false "char<? should return false for unmatched characters"
    (lambda ()
        (char<? #\A #\A)))

(expect-false "char<? should return false for unmatched characters"
    (lambda ()
        (char<? #\A #\B #\C #\D #\A 'NON-CHAR)))

;;
;; char<=?
;;

(expect-true "char<=? should return true for one character"
    (lambda ()
        (char<=? #\A)))

(expect-true "char<=? should return true for two characters"
    (lambda ()
        (char<=? #\A #\B)))

(expect-true "char<=? should return true for more characters"
    (lambda ()
        (char<=? #\A #\B #\B #\C #\D #\E)))

(expect-false "char<=? should return false for unmatched characters"
    (lambda ()
        (char<=? #\B #\A)))

(expect-false "char<=? should return false for unmatched characters"
    (lambda ()
        (char<=? #\A #\B #\C #\D #\D #\A 'NON-CHAR)))

;;
;; char>?
;;

(expect-true "char>? should return true for one character"
    (lambda ()
        (char>? #\A)))

(expect-true "char>? should return true for two characters"
    (lambda ()
        (char>? #\B #\A)))

(expect-true "char>? should return true for more characters"
    (lambda ()
        (char>? #\E #\D #\C #\B #\A)))

(expect-false "char>? should return false for unmatched characters"
    (lambda ()
        (char>? #\A #\A)))

(expect-false "char>? should return false for unmatched characters"
    (lambda ()
        (char>? #\D #\C #\B #\A #\A 'NON-CHAR)))

;;
;; char>=?
;;

(expect-true "char>=? should return true for one character"
    (lambda ()
        (char>=? #\A)))

(expect-true "char>=? should return true for two characters"
    (lambda ()
        (char>=? #\B #\A #\A)))

(expect-true "char>=? should return true for more characters"
    (lambda ()
        (char>=? #\E #\D #\C #\C #\B #\A)))

(expect-false "char>=? should return false for unmatched characters"
    (lambda ()
        (char>=? #\A #\B)))

(expect-false "char>=? should return false for unmatched characters"
    (lambda ()
        (char>=? #\D #\C #\B #\A #\A #\D 'NON-CHAR)))

