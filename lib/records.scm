;;;
;;; Basic procedures used in the definition of records.
;;; 

;; Note: these procedures are actually used by the compiler

;; Returns true if obj is a record
(define (record? obj) (asm(obj) record?))


;; The internals of define-record-type
(define (record-type-factory . args)
  ;; creates an a record primitive with the given size
  (define (make-record size)
    (asm (size) record))

  (define (record-type-id rec)
    (asm 0 (rec) idx@))

  (define (set-record-type-id rec type)
    (asm 0 (type) (rec) idx! ()))

  ;; extract clauses
  (define name-clause (car args))
  (define const-clause  (car (cdr args)))
  (define pred-clause (car (cdr (cdr args))))
  (define fields-list (cdr (cdr (cdr args))))

  ;; Setup the constructor
  (define field-count (- (length const-clause) 1))

  (display "Setting up define-record")
  (newline)
  (display "Name:")
  (display nam-clause)
  (newline)
  (display "Const:")
  (display const-clause)
  (newline)
  (display "Predicate:")
  (display const-clause)
  (newline)
  (display "Fields:")
  (display const-clause)
  (newline))

