
;; Setup functions to bind a dynamic library
(define import-factory
  (lambda (library)
    (lambda (func . args)
      (asm (args) (library) (func) @ call_ext))))

(define bind-in
  (lambda (alist closure)
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
            
            dup cdr swap car bind 
            ret

          bind-in-done: ())
        (bind-in (cdr alist) closure)))))


(define import-bind
  (lambda (path)
    (asm
      (path) import
      ('bindings) bind
      ('lib) bind ())
  
    (define caller (import-factory lib))

    ;; Add bindings to the caller closure
    (bind-in bindings caller)
    caller))
        
     

(define io (import-bind "build/src/libinsomniac_io/libinsomniac_io"))

(display "Calling: ")

(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)
(io 'io-hello-world)

(io 'io-say "hello")
(display #\newline)

