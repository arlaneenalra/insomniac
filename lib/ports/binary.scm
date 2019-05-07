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

;; Build a binary port
(define (make-binary-port fd writable)
	(make-port
		fd
		writable
		'<binary>
		(if writable raw-write raw-read)
		binary-close-port))

;;
;; Standard IO ports
;;

(define current-input-port
    (make-parameter (make-binary-port 0 #f)))

(define current-output-port
    (make-parameter (make-binary-port 1 #t)))

(define current-error-port
    (make-parameter (make-binary-port 2 #t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Binary port operations
;;

(define (open-binary-output-file file)
    (make-binary-port
        (raw-open file #t)
        #t))

(define (open-binary-input-file file)
    (make-binary-port
        (raw-open file #f)
        #f))

