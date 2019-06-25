;;;
;;; Tests for stream handling
;;;

(include "../src/lib/test/expect.scm")

(include "../src/core/lexer/core.scm")

(expect "Verify that reading from a stream works"
    (lambda ()
        (with-input-port (open-input-string "1234")
            (lambda ()
                (define next-char (char-stream 2)) 
                (list
                    (next-char)
                    (next-char)
                    (next-char)
                    (next-char)
                    (next-char)))))

    (list
        (eof-object)
        #\4 #\3 #\2 #\1))

(expect "Verify that we can put values back onto the stream"
    (lambda ()
        (with-input-port (open-input-string "1234")
            (lambda ()
                (define next-char (char-stream 2))

                (list
                    (next-char)
                    (next-char)
                    (next-char #\4)

                    (next-char)
                    (next-char)
                    (next-char)
                    (next-char)
                    (next-char)))))
    (list
        (eof-object)
        #\4
        '()
        (eof-object)
        #\4 #\3 #\2 #\1))

