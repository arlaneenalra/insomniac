;;;
;;; Tests for define-record-type
;;;

(include "../src/lib/test/expect.scm")

(define-record-type <point-3d>
  (point-3d x y z)
  point-3d?
  (x get-x)
  (y get-y set-y!)
  (z get-z))

(define point (point-3d 2 4 8))

(expect-true "A record should be a record"
             (lambda () (record? point)))

(expect-true "A point record should be a point"
             (lambda () (point-3d? point)))

(expect-false "A record should not be a vector"
              (lambda () (vector? point)))


(expect "A record accessor should retrieve the value of it's field"
        (lambda () (list (get-x point)
                         (get-y point)
                         (get-z point)))
        '(2 4 8))

(expect "A record setter should update the value of it's field"
        (lambda ()
          (set-y! point 64)

          (list (get-x point)
                (get-y point)
                (get-z point)))
        '(2 64 8))

