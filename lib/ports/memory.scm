;;;
;;; In Memory Ports
;;;

;; Add a new bytevector the stack
(define (mem-binary-write u8 num fd)
    (set-car! fd 
        (cons (bytevector-copy u8 0 num) (car fd)))
    num) 

(define (mem-binary-read num port)
    (define offset (car port))
    (define new-offset (+ offset num))
    (define u8 (cdr port))

    (if (>= offset (bytevector-length u8))
        (bytevector)
        (begin
            (set-car! port new-offset)
            (bytevector-copy u8 offset new-offset))))

(define <binary-memory-port>
    (make-port-ops
        '<binary>
        mem-binary-write
        mem-binary-read
        (lambda (port) #t)
        (lambda (port) #t)))

;;
;; Binary memory ports
;;

(define (open-input-bytevector u8)
    (make-port (cons 0 u8) #f #t <binary-memory-port>))

(define (open-output-bytevector)
    (make-port (cons '() '()) #t #t <binary-memory-port>))

(define (get-output-bytevector out-port)
    (apply bytevector-append
        (reverse (car (port-fd out-port)))))

;;
;; Textual memory ports
;;

(define (open-input-string str)
    (make-port
        (open-input-bytevector (string->u8 str))
        #f
        #t
        <textual-file-port>))

(define (open-output-string)
    (make-port
        (open-output-bytevector)
        #t
        #t
        <textual-file-port>))

(define (get-output-string port)
    (u8->string
        (get-output-bytevector (port-fd port))))

