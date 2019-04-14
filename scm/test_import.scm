
(define io (import-bind "build/src/libinsomniac_io/libinsomniac_io"))

(display "Calling: ")

(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)

(io 'io-say "hello")
(display #\newline)

(display io)
(newline)
