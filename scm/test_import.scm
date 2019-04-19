
(define io (import-bind "build/src/libinsomniac_io/libinsomniac_io"))

(display "Calling: ")

(io 'io-hello-world)

(display (io 'stdin))
(newline)
(display (io 'stdout))
(newline)
(display (io 'stderr))
(newline)

(define (it-works! n)
    (io 'io-say (io 'stdout) "Testing out")
    (newline)
    (io 'io-say (io 'stderr) "Testing err")
    (newline)

    (if (> 0 n) 
        #t
        (it-works! (- n 1))))

(it-works! 100)

