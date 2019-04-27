;;;
;;; Functions for dealing with dlls (.so and .dylib)
;;;

;; Setup functions to bind a dynamic library
(define (import-factory library)
    (lambda (func . args)
      (asm (args) (library) (func) @ call_ext)))

;; Bind an alist of symbol->library function references into the current 
;; environment
(define (bind-in alist closure)
    (if (null? alist)
      '()
      (begin
        (asm
          ;; This does not follow the normal calling convention
          proc bind-in-done ;; setup return
          
          ;; Setup arguments list
          (alist) car
          
          proc do-bind (closure) adopt
          ret ;; jump/call do-bind

          do-bind:
            ;; An alist has the key and value backwards for bind. 
            dup cdr swap car bind 
            ret

          bind-in-done: ())
        (bind-in (cdr alist) closure))))


(define (import-bind path)
    (asm
      (path) import
      ('bindings) bind
      ('lib) bind ())

    (define caller (import-factory lib))

    ;; Add bindings to the caller closure
    (bind-in bindings caller)
    caller)
 
