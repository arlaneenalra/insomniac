;;;
;;; Code generation for Mac ARM64.
;;; Produces bytecode-in-native-assembly, matching the output of compiler.c:
;;; an ARM64 _main that calls _run_scheme, with scheme bytecode embedded in the
;;; data section as .byte directives.
;;;


(define *previous-label* 0)

(define (mac-labeler)
    (define label (string-append "L." (number->string *previous-label*)))
    (set! *previous-label* (+ 1 *previous-label*))
    label)

;; Register definitions are unused in the bytecode approach but required
;; by the target record.
(define mac-abi-register
    (abi-register-builder
        "x0"
        (vector "x0" "x1" "x2" "x3" "x4" "x5" "x6" "x7")))

(define mac-scratch-register
    (abi-register-builder
        "x0"
        (vector "x8" "x9")))

;; Preamble: ARM64 _main that calls _run_scheme, then opens the data section
;; and writes the GC meta-object header for scheme_code.
;; The bytecode size is computed via label arithmetic (L.bc_end - L.bc_start).
(define (mac-preamble)
    (write-string
"
    .section __TEXT,__text
    .global _main
    .p2align 2
_main:
    .cfi_startproc
    stp    x29, x30, [sp, #-16]!
    .cfi_def_cfa_offset 16
    .cfi_offset w29, -16
    .cfi_offset w30, -8
    mov    x29, sp
    .cfi_def_cfa_register w29
    bl     _run_scheme
    ldp    x29, x30, [sp], #16
    ret
    .cfi_endproc

.section __DATA,_data
    .p2align 3
    .long 2
    .long 0
    .quad (L.bc_end - L.bc_start)
    .long -1
    .global _scheme_code
_scheme_code:
L.bc_start:
"))

;; Postamble: close the bytecode region, emit scheme_code_size, and emit
;; empty debug stubs required by run_scheme.
(define (mac-postamble)
    (write-string
"
L.bc_end:
    .p2align 3
    .global _scheme_code_size
_scheme_code_size:
    .quad (L.bc_end - L.bc_start - 1)

    .global _debug_files
_debug_files:
    .global _debug_files_count
_debug_files_count:
    .quad 0

    .global _debug_ranges
_debug_ranges:
    .global _debug_ranges_count
_debug_ranges_count:
    .quad 0
"))

(define *MAC-ARM64*
    (target
        mac-preamble
        mac-postamble
        mac-labeler
        mac-abi-register
        mac-scratch-register))
