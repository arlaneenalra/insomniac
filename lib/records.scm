;;;
;;; Basic procedures used in the definition of records.
;;; 

;; This code is horrible, I'll need to revisit it later 

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
  (asm (idx) (obj) (rec) idx! ()))

;; Record constructor factory
(define (record-constructor-factory type-id size)
  ;; account for the type id
  (set! size (+ 1 size))

  ;; set all values in a record
  (define (set-values rec idx field-list)
    (if (null? field-list)
      rec
      (begin
        (record-set! rec idx (car field-list))
        (set-values rec (+ 1 idx) (cdr field-list)))))

  
  ;; the actual constructor method
  (lambda fields
    (define rec (make-record size))
    (record-set! rec 0 type-id)
    (set-values rec 1 fields)))

;; define a record predicate factory
(define (record-predicate-factory type-id)
  (lambda (obj)
    (and (record? obj) (eq? type-id (record-ref obj 0)))))

;; return a record field getter
(define (record-getter-factory idx)
  (lambda (obj) (record-ref obj idx)))

;; return a record field setter
(define (record-setter-factory idx)
  (lambda (obj value) (record-set! obj idx value)))

;; setup getter/setters 
(define (record-field-factory bindings idx accessor)
  (cons
    (cons (car accessor) (record-getter-factory idx))
    (if (null? (cdr accessor))
      bindings
      (cons
        (cons (car (cdr accessor)) (record-setter-factory idx))
        bindings))))

;; Walk list of fields and build accessors as needed
(define (record-accessor-factory bindings idx fields access)
  (if (null? fields) 
    bindings
    (begin
      ;; retrieve access for this field
      (define accessors
        (assoc (car fields) access))

      (record-accessor-factory
        (if (not accessors)
          bindings
          (record-field-factory bindings idx (cdr accessors)))
        (+ 1 idx) (cdr fields) access))))

;; Note: This binding/symbol is used internally by the compiler
;; The internals of define-record-type
(define (record-type-factory . rec-def)
  
  (define type-id (next-record-type))

  (define name-clause (car rec-def))
  (define const-clause  (car (cdr rec-def)))
  (define pred-clause (car (cdr (cdr rec-def))))
  (define fields-clause (cdr (cdr (cdr rec-def))))

  ;; setup the field count minus one for the name 
  (define field-count (- (length const-clause) 1))

  ;; the record alist to bind
  ;;  (cons name-clause type-id)
  (define binding-list
    (list
      (cons pred-clause (record-predicate-factory type-id)) 
      (cons (car const-clause) (record-constructor-factory type-id field-count))
    ))

  ;; Setup field accessors
  (record-accessor-factory binding-list 1 (cdr const-clause) fields-clause))



