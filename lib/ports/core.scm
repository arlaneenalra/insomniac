;;;
;;; Core Ports Code
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

;; Define a port type
(define-record-type <port>
    (make-port fd writable type op closer)
    port?
    (fd port-fd)
    (writable port-writable)
    (type port-type)
    (op port-op)
    (closer close-op))

;;
;; Predicates
;;

;; Check to see if the port is an input port
(define (input-port? port)
    (not (port-writable port)))

;; Check to see if the port is an output port
(define (output-port? port)
    (port-writable port))

;; Check for a binary port
(define (binary-port? port)
    (eq? (port-type port) '<binary>))

;; Check for a textual port
(define (textual-port? port)
    (eq? (port-type port) '<text>))

;;
;; Close port
;;

(define (close-port port)
    ((close-op port) port))

(define close-input-port close-port)
(define close-output-port close-port)

;;
;; Standard port operations
;;

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

    (define u8-slice (slice u8 start end))

    ;;; TODO Fully implement write
    ((port-op port) u8-slice (bytevector-length u8-slice) (port-fd port)))

(define (read-bytevector k . args)
    (define port
        (if (> (length args) 0)
            (car args)
            (current-input-port)))

    (define u8-read ((port-op port) k (port-fd port)))

    (if (> (bytevector-length u8-read) 0)
        u8-read
        (eof-object)))

