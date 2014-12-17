;;;
;;; Basic procedures used in the definition of records.
;;; 

;; Note: these procedures are actually used by the compiler

;; Returns true if obj is a record
(define (record? obj) (asm(obj) record?))


;; The internals of define-record-type
(define (record-type-factory rec-def)
  ;; creates an a record primitive with the given size
  (define (make-record size)
    (asm (size) record))

  (define (record-type-id rec)
    (asm 0 (rec) idx@))

  (define (set-record-type-id rec type)
    (asm 0 (type) (rec) idx! ()))

  ;; extract clauses
  (define name-clause (car rec-def))
  (define const-clause  (car (cdr rec-def)))
  (define pred-clause (car (cdr (cdr rec-def))))
  (define fields-list (cdr (cdr (cdr rec-def))))

  ;; Setup the constructor
  (define field-count (- (length const-clause) 1))

  (display "Setting up define-record")
  (newline)
  (display "Name:")
  (display name-clause)
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

