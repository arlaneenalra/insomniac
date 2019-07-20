;;;
;;; An assmbler for the internal assembly.
;;;

(include "asm/lexer.scm")
(include "asm/target/core.scm")

;; Configuration options for the Assembler.
(define-record-type :insc-config
    (make-insc-config name source output)
    insc-config?
    (name insc-config-name)
    (source insc-config-source insc-config-source-set!)
    (output insc-config-output insc-config-output-set!))

;; Very crude command line argument processor.
(define (build-config cmd-line)
    (let*
        ((name (car cmd-line))
         (args (cdr cmd-line))
         (config (make-insc-config name "" "a.out.s"))
         (usage (lambda ()
            (display name)
            (display " <source>")
            (exit 1)))

         (walker (lambda (config cmd-line)
                    (cond
                        ((null? cmd-line) config)
                        ((not (eq? "" (car cmd-line)))
                            (insc-config-source-set! config (car cmd-line))
                            (walker config (cdr cmd-line)))
                        (else (usage))))))


        (if (eq? 0 (length args))
            (usage)
            (walker config args))))


;; Write out
(define (assemble-to-file outfile)
    (with-output-to-file
        outfile
        (lambda ()
            (define stream (char-stream 4096))
            (define (token-stream)
                (asm-lexer stream))

            (assemble *MAC-x86-64* token-stream))))

(let*
    ((config (build-config (command-line))))
    
    (display "Assembling: ")
    (display (insc-config-source config))
    (newline)

    (with-input-from-file
        (insc-config-source config)
        (lambda ()
            (assemble-to-file
                (insc-config-output config)))))
(newline)

