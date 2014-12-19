;;;
;;; Basic procedures used in the definition of records.
;;; 

;; Note: these procedures are actually used by the compiler

;; Id value for next record type 
(define *record-id* 0)

;; returns a record id unique in the system
(define (next-record-type)
  (define type-id *record-id*)
  (set! *record-id* (+ 1 *record-id*))
  type-id)

;; Returns true if obj is a record
(define (record? obj) (asm(obj) record?))


;; creates an a record primitive with the given size
(define (make-record size)
  (asm (size) record))

;; accessors for record fields
(define (record-ref rec idx)
  (asm (idx) (rec) idx@))

(define (record-set! rec idx obj)
  (asm (idx) (type) (rec) idx! ()))

  ;; Generic record constructor
(define (record-constructor type size)
  (define rec (make-record size))
  (set-record-type-id rec type)
  rec)

;; The internals of define-record-type
(define (record-type-factory . args)
  (define rec-def (car args))

  (define type-id (next-record-type))

  (define name-clause (car rec-def))
  (define const-clause  (car (cdr rec-def)))
  (define pred-clause (car (cdr (cdr rec-def))))
  (define fields-clause (cdr (cdr (cdr rec-def))))

  ;; Setup the constructor .. this is subtlely +1 by choice
  ;; (define field-count (length const-clause))

  (display "Setting up define-record")
  (newline)
  (display "Name:")
  (display name-clause)
  (newline)
  (display "Const:")
  (display const-clause)
  (newline)
  (display "Predicate:")
  (display pred-clause)
  (newline)
  (display "Fields:")
  (display fields-clause)
  (newline)
  

  )

