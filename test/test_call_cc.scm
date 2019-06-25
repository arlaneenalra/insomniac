;;;
;;; Some simple call/cc tests.
;;;

(include "../lib/test/expect.scm")

(expect "Check that the simplest call/cc works"
    (lambda ()
        (call/cc (lambda (x) (x -1))))
    -1)

(expect "Check something a little more complex"
    (lambda ()
        (call-with-current-continuation
            (lambda (exit)
                (for-each
                    (lambda (x)
                        (if (> 0 x)
                            (exit x)))
                    '(54 0 37 -3 245 19)) #t)))
    -3)

(expect "Test dynamic-wind"
    (lambda ()
        (define path '())
        (define c #f)

        (define (add s)
            (set! path (cons s path)))

        (dynamic-wind
            (lambda () (add 'connect))
            (lambda ()
                (add (call/cc
                    (lambda (c0)
                        (set! c c0) 'talk1))))
            (lambda () (add 'disconnect)))

        (if (< (length path) 4)
            (c 'talk2)
            (reverse path)))

        '(connect talk1 disconnect
            connect talk2 disconnect))

(define (build-winder adder before after)
    (lambda (proc)
        (dynamic-wind
            (lambda () (adder before))
            (lambda () (proc adder))
            (lambda () (adder after)))))

(expect "Test double wind"
    (lambda ()
        (define path '())
        (define (add s)
            (set! path (cons s path))
            path)

        (define winder (build-winder add 'connect 'disconnect))
        (define c #f)

        (winder (lambda (add1)
            (winder (lambda (add)
                (add (call/cc
                    (lambda (c0)
                        (set! c c0) 'talk1)))))))

        (if (< (length path) 6)
            (c 'talk2)
            (reverse path)))

        '(connect connect talk1 disconnect disconnect
            connect connect talk2 disconnect disconnect))

(expect "Test double wind order"
    (lambda ()
        (define path '())
        (define (add s)
            (set! path (cons s path))
            path)

        (define winder (build-winder add 'connect 'disconnect))
        (define winder2 (build-winder add 'conn2 'disconn2))
        (define c #f)

        (winder2 (lambda (add1)
            (winder (lambda (add)
                (add (call/cc
                    (lambda (c0)
                        (set! c c0) 'talk1)))))))

        (if (< (length path) 6)
            (c 'talk2)
            (reverse path)))

        '(conn2 connect talk1 disconnect disconn2
            conn2 connect talk2 disconnect disconn2))


