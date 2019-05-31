;;;
;;; Some looping constructs
;;;


;; convert parallel lists into a single list
;; of lists
(define (prep-args val-list)

  ;; make a list from the a row of the
  ;; parallel lists
  (define (combind val-list flat-list)

    (if (null? val-list)
	(reverse flat-list)
	(combind (cdr val-list)
		 (cons (car (car val-list)) flat-list))))

  (define (next val-list new-val-list)
    (cond
     ((null? val-list)
      (reverse new-val-list))

     ((null? (car val-list))
	     '())

     (else
      (next (cdr val-list)
	    (cons (cdr (car val-list)) new-val-list)))))


  (define (inner val-list args-list)
	(define next-val (next val-list '()))

      (if (null? next-val)
	  (reverse args-list)
	  (inner next-val (cons
			   (combind val-list '())
			   args-list))))


  (if (= 1 (length val-list))
    (car val-list)
    (inner val-list '())))
	


;; a for-each routine
(define (for-each proc . val-list)

  (define (inner val-list)
    (if (or (null? val-list) (null? (car val-list)))
	'()
	(begin
	  (apply proc (list (car val-list)))
	  (inner (cdr val-list)))))

  (inner (prep-args val-list)))


;; map
(define (map proc . val-list)

  (define (inner val-list result)
    (if (or (null? val-list) (null? (car val-list)))
	(reverse result)
	(inner (cdr val-list)
	       (cons
		(apply proc (list (car val-list)))
		result))))
	
  (inner (prep-args val-list) '()))

