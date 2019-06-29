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
    (make-port-ops binary writer reader closer flusher)
    port-type?
    (binary port-type-binary?)
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

;; Check for a binary port
(define (binary-port? port)
    (define type (port-type port))
    (eq? '<binary> (port-type-binary? type)))

(define (textual-port? port)
    (define type (port-type port))
    (eq? '<textual> (port-type-binary? type)))

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
;; Flush an output port
;;

(define (flush-output-port . args)
    (let*
        ((port
            (if (null? args)
                (current-output-port)
                (car args)))
         (type (port-type port))
         (flusher (port-type-flushertype))
         (fd (port-fd port)))
         
        (flusher fd)))

;;
;; Standard port operations
;;
(define (writer-factory len-func slicer)

    (define (write-slice u8 . args)
        (define port (current-output-port))
        (define start 0)
        (define end (len-func u8))

        (define (process-args sym args)
            (if (or (null? args) (null? sym))
                #t
                (begin
                    (set! (car sym) (car args))
                    (process-args (cdr sym) (cdr args)))))
        (process-args '(port start end) args)

        (define u8-slice (slicer u8 start end))

        ;;; TODO Fully implement write
        (let*
            ((type (port-type port))
             (writer (port-type-writer type))
             (fd (port-fd port)))
            
            (writer u8-slice (len-func u8-slice) fd)))
    write-slice)

(define (reader-factory len-func)
    (lambda (k . args)
        (define port
            (if (> (length args) 0)
                (car args)
                (current-input-port)))

        (define value-read 
            (let*
                ((type (port-type port))
                 (reader (port-type-reader type))
                 (fd (port-fd port)))
                
                (reader k fd)))

        (if (> (len-func value-read) 0)
            value-read
            (eof-object))))

(define (call-with-port port proc)
    (dynamic-wind
        (lambda ())
        (lambda () (proc port))
        (lambda () (close-port port))))

(define (with-input-port port thunk)
    (call-with-port port
        (lambda (port)
            (param-wrap current-input-port port thunk))))

(define (with-output-port port thunk)
    (call-with-port port
        (lambda (port)
            (param-wrap current-output-port port thunk))))

