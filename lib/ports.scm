;;;
;;; Port code
;;;

;; Create the eof-object
(define-record-type <eof>
    (raw-eof-object)
    eof-object?)

;; Define a singleton eof object
(define eof-object 
    ((lambda (eof)
        (lambda () eof))
     (raw-eof-object)))

;; Open a file
(define (raw-open path write)
    (asm (path) (write) open ('fd) bind ())
    fd)

;; Close a file
(define (raw-close fd)
    (asm (fd) close ()))

;; Write to a file
(define (raw-write u8 num fd)
    (asm (u8) (num) (fd) write ('written) bind ())
    written)

;; Read from a file
(define (raw-read num fd)
    (asm (num) (fd) read ('read) bind ())
    read)

;; Define a port type
(define-record-type <port>
    (make-port fd writable type op)
    port?
    (fd port-fd)
    (writable port-writable)
    (type port-type)
    (op port-op))

;; Check to see if the port is an input port 
(define (input-port? port)
    (not (port-writable port)))

;; Check to see if the port is an output port
(define (output-port? port)
    (port-writable port))

;; Check for a textual port
(define (textual-port? port)
    (eq? (port-type port) '<text>)) 

(define (close-port port)
    (raw-close (port-fd port)))

(define close-input-port close-port)
(define close-output-port close-port)


(define current-input-port
    (make-parameter 
        (make-port 0 #f '<binary> raw-read))) 

(define current-output-port
    (make-parameter 
        (make-port 1 #t '<binary> raw-write))) 

(define current-error-port
    (make-parameter 
        (make-port 2 #t '<binary> raw-write))) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Binary port operations
;;

;; Check for a binary port
(define (binary-port? port)
    (eq? (port-type port) '<binary>))

(define (open-binary-output-file file)
    (make-port
        (raw-open file #t)
        #t
        '<binary>
        raw-write))

(define (open-binary-input-file file)
    (make-port
        (raw-open file #f)
        #f
        '<binary>
        raw-read))

(define (write-bytevector u8 . args)
    (define port (current-output-port))
    (define start 0)
    (define end (bytevector-length u8))

    (define (process-args sym args)
        (if (or (null? args) (null? sym))
            #t 
            (begin
                (set! (car sym) (car args))
                (process-args (cdr sym) (cdr args)))))
    (process-args '(port start end) args)

    ;;; TODO Fully implement write
    ((port-op port) u8 end (port-fd port)))

(define (read-bytevector k . args)
    (define port
        (if (> (length args) 0)
            (car args)
            (current-input-port)))

    (define u8-read ((port-op port) k (port-fd port)))

    (if (> (bytevector-length u8-read) 0)
        u8-read
        (eof-object)))

    

