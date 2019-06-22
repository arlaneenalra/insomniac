;;
;;
;; A simple repl
;;
;;


(define (repl-read)
    (display ">")

    (let*
        ((value (read-string 10)))

        (newline)
        (display "< ")
        (display value)
        (newline)

        (if (eof-object? value)
            #t
            (repl-read))))

(display (command-line)) (newline)

(repl-read)


