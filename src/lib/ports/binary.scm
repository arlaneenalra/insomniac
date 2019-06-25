;;;
;;; Binary Ports
;;;

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

;; Close a binary port
(define (binary-close-port port)
    (raw-close (port-fd port)))

;; Setup type for binary file ports
(define <binary-file-port>
    (make-port-ops
        '<binary>
        raw-write
        raw-read
        raw-close
        (lambda (port) #t))) ;; Does nothing

;; Build a binary port
(define (make-binary-port fd writable)
	(make-port fd writable #t <binary-file-port>))

;;
;; Binary port openers 
;;

(define (open-binary-output-file file)
    (make-binary-port (raw-open file #t) #t))

(define (open-binary-input-file file)
    (make-binary-port (raw-open file #f) #f))


;;
;; Standard IO operations
;;
(define write-bytevector
    (writer-factory bytevector-length bytevector-copy))

(define read-bytevector
    (reader-factory bytevector-length))


