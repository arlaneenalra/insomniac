;;;
;;; Textual Ports
;;;

;;
;; Standard IO ports
;;


;; Setup type for text file ports
(define <textual-file-port>
    (begin

        ;; We assume a binary port here and 
        ;; call writer directly to avoid 
        ;; doubling up on the slice logic
        (define (text-write str num fd)
            (let*
                ((type (port-type fd))
                 (writer (port-type-writer type))
                 (real-fd (port-fd fd))
                 (u8 (string->u8 str)))

            (writer u8 num real-fd)))

        ;; We assume a binary port here and 
        ;; call reader directly to avoid
        ;; doubling the read logic
        (define (text-read num fd)
            (let*
                ((type (port-type fd))
                 (reader (port-type-reader type))
                 (real-fd (port-fd fd)))
            
                (u8->string (reader num real-fd))))

        ;; fd is a binary port
        (define (text-close fd)
            (close-port fd))

        (define (text-flush fd)
            (flush-output-port fd))

        (make-port-ops
            '<textual>
            text-write
            text-read
            text-close
            text-flush)))

;;
;; Textual port openers
;;

(define (open-output-file file)
    (make-port
        (open-binary-output-file file)
        #t
        #t
        <textual-file-port>))

(define (open-input-file file)
    (make-port
        (open-binary-input-file file)
        #f
        #t
        <textual-file-port>))

(define current-input-port
    (make-parameter
        (make-port
            (make-binary-port 0 #f)
            #f
            #t
            <textual-file-port>)))

(define current-output-port
    (make-parameter
        (make-port
            (make-binary-port 1 #t)
            #t
            #t
            <textual-file-port>)))

(define current-error-port
    (make-parameter
        (make-port
            (make-binary-port 2 #t)
            #t
            #t
            <textual-file-port>)))

;;
;; Standard IO operations
;;
(define write-string
    (writer-factory string-length substring))

(define read-string
    (reader-factory string-length))

(define (call-with-input-file str proc)
    (call-with-port (open-input-file str) proc))

(define (call-with-output-file str proc)
    (call-with-port (open-output-file str) proc))

(define (with-input-from-file str thunk)
    (call-with-input-file str
        (lambda (port)
            (param-wrap current-input-port port thunk))))

(define (with-output-to-file str thunk)
    (call-with-output-file str
        (lambda (port)
            (param-wrap current-output-port port thunk))))

