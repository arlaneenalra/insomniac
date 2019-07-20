;;;
;;; Code generation primtives for Mac Intel x64 machines.
;;;


(define *previous-label* 0)

(define (mac-labeler)
    (define label (string-append "L." (number->string *previous-label*)))
    (set! *previous-label* (+ 1 *previous-label*))

    label)

;; Note: this is the C abi 
;; Syscalls use rdi rsi rdx r10 r8 r9 instead
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

# Map a hunk of ram 
    movq $0x20000C5, %rax  # mmap syscall
    xorq %rdi, %rdi        # addr - we don't care 
    movq $0x10000000, %rsi  # size 
    movq $0x03, %rdx       # read/write
    movq $0x1002, %r10     # MAP_ANON
    movq $-1, %r8          # offset doesn't matter
    xorq %r9, %r9          # no file descriptor
    syscall


    movq %rax, L.heap(%rip) # save off the pointer to our heap
    movq %rax, L.heap_head(%rip) # save off the pointer to our heap

# User code begins
"))

;; Postable code that appears at the end of every application.
(define (mac-postamble)
    ; Make sure the exit code is set correctly
    (write-op "popq" "%rax")

    (write-op "popq" "%rbp")
    (write-op "retq")

    (write-string *newline*)
    (write-directive "section" "__DATA" "_data")

    (write-string "
# pointer for pre-allocated heap
L.heap: .quad 0
L.heap_head: .quad 0
")

    (write-comment "-- Strings")
    (emit-string-list)
    (write-comment "-- Numbers")
    (emit-fixnum-list)
    (write-comment "-- Characters")
    (emit-char-list))

(define *MAC-x86-64*
    (target
        mac-preamble
        mac-postamble
        mac-labeler
        mac-abi-register
        mac-scratch-register))
