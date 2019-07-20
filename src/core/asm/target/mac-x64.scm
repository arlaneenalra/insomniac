;;;
;;; Code generation primtives for Mac Intel x64 machines.
;;;

;; Preamble code that appears at the start of every application.
(define (mac-preamble)
    (write-string
"
.section __TEXT,__text
    .global _main
    .p2align 4, 0x90
_main:
    pushq  %rbp
    movq   %rsp, %rbp
    xorl   %eax, %eax

"))


;; Postable code that appears at the end of every application.
(define (mac-postamble)
    ; Make sure the exit code is set correctly
    (write-op "popq" "%rax")

    (write-op "popq" "%rbp")
    (write-op "retq")

    (write-string *newline*)
    (write-directive "section" "__DATA" "_data")

    (emit-string-list)
    (emit-fixnum-list))

(define *previous-label* 0)

(define (mac-labeler)
    (define label (string-append "L." (number->string *previous-label*)))
    (set! *previous-label* (+ 1 *previous-label*))

    label)

(define mac-abi-register
    (abi-register-builder
        "%rax"
        (vector "%rdi" "%rsi" "%rdx" "%rcx" "%r8" "%r9")))

(define mac-scratch-register
    (abi-register-builder
        "%rax" 
        (vector "%r10" "%r11")))

;; Preserved registers
;; rbx rsp rbp r12 r13 r14 r15

(define *MAC-x86-64*
    (target
        mac-preamble
        mac-postamble
        mac-labeler
        mac-abi-register
        mac-scratch-register))
