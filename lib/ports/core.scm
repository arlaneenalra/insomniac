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

;; Define a type for ports.
(define-record-type <port-ops>
    (make-port-ops writer reader closer flusher)
    port-type?
    (writer port-type-writer)
    (reader port-type-reader)
    (closer port-type-closer)
    (flusher port-type-flusher))

;; Define the ports themselves.
(define-record-type <port>
    (make-port fd writable open type)
    port?
    (fd port-fd)
    (writable port-writable)
    (open port-open? port-set-open!)
    (type port-type)) 


;;
;; Predicates
;;

;; Check to see if the port is an input port
(define (input-port? port)
    (not (port-writable port)))

;; Check to see if the port is an output port
(define (output-port? port)
    (port-writable port))

(define (output-port-open? port)
    (and (output-port? port)
         (port-open? port)))

(define (input-port-open? port)
    (and (input-port? port)
         (port-open? port)))

;;
;; Close port
;;

(define (close-port port)
    (let*
        ((type (port-type port))
         (closer (port-type-closer type))
         (fd (port-fd port)))
        
        (port-set-open! port #f)
        (closer fd)))

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
    (let*
        ((type (port-type port))
         (writer (port-type-writer type))
         (fd (port-fd port)))
        
        (writer u8-slice (bytevector-length u8-slice) fd)))

(define (read-bytevector k . args)
    (define port
        (if (> (length args) 0)
            (car args)
            (current-input-port)))

    (define u8-read 
        (let*
            ((type (port-type port))
             (reader (port-type-reader type))
             (fd (port-fd port)))
            
            (reader k fd)))

    (if (> (bytevector-length u8-read) 0)
        u8-read
        (eof-object)))

