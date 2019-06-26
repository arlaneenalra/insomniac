;;;
;;; Tests for stream handling
;;;

(include "../src/lib/test/expect.scm")

(include "../src/core/lexer/stream.scm")

(expect "Verify that reading from a stream works"
    (call-with-input "1234"
        (lambda ()
            (define next-char (char-stream 2)) 
            (list
                (next-char)
                (next-char)
                (next-char)
                (next-char)
                (next-char))))

    (list
        (eof-object)
        #\4 #\3 #\2 #\1))

(expect "Verify that we can put values back onto the stream"
    (call-with-input "1234"
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
                (next-char))))

    (list
        (eof-object)
        #\4
        '()
        (eof-object)
        #\4 #\3 #\2 #\1))

