;;;
;;; Bytecode emitter: translates Insomniac assembly tokens into .byte directives.
;;; Matches the bytecode encoding produced by libinsomniac_asm/asm_core.c.
;;;
;;; Opcode values come from src/include/ops.h (sequential enum starting at 0).
;;; Encoding rules:
;;;   Simple opcodes:  1 byte  (the opcode value)
;;;   Fixnum literal:  1 byte opcode + 8 bytes little-endian value (.quad)
;;;   Char literal:    1 byte opcode + 4 bytes little-endian value (.long)
;;;   String/Symbol:   1 byte opcode + 8 bytes length (.quad) + raw char bytes
;;;   Jump opcodes:    1 byte opcode + 8 bytes relative offset (.quad label-.-8)
;;;

(define *newline* (list->string '(#\newline)))

;; Emit a single opcode byte.
(define (emit-op op-num)
    (write-string "    .byte   ")
    (write-string (number->string op-num))
    (write-string *newline*))

;; Emit an 8-byte value via .quad (used for fixnum values and string lengths).
(define (emit-quad-str s)
    (write-string "    .quad   ")
    (write-string s)
    (write-string *newline*))

;; Emit a 4-byte value via .long (used for char values).
(define (emit-long-str s)
    (write-string "    .long   ")
    (write-string s)
    (write-string *newline*))

;; Emit string content byte-by-byte to avoid assembler escape issues.
(define (emit-string-bytes str)
    (define (walker lst)
        (if (not (null? lst))
            (begin
                (write-string "    .byte   ")
                (write-string (number->string (char->integer (car lst))))
                (write-string *newline*)
                (walker (cdr lst)))))
    (walker (string->list str)))

;; Extract the jump target label name from a jump token.
;; Jump tokens are chain-rules: (op-token whitespace-token label-token).
(define (jump-target token)
    (define label-token (car (cdr (cdr (token-text token)))))
    (token-text label-token))

;; Build a jump emitter for an opcode with a label target.
;; Emits: 1 byte opcode + .quad (label - . - 8)
;; The offset formula "label - . - 8" matches asm_core.c's rewrite_jumps:
;;   target = label_addr - jump_addr - 8
;; where jump_addr is the position of the 8-byte field (= . here).
(define (make-jump-emitter op-num)
    (lambda (target token)
        (emit-op op-num)
        (write-string "    .quad   ")
        (write-string (jump-target token))
        (write-string " - . - 8")
        (write-string *newline*)))

(define emit-call     (make-jump-emitter 24))  ;; OP_CALL
(define emit-proc     (make-jump-emitter 26))  ;; OP_PROC
(define emit-jmp      (make-jump-emitter 27))  ;; OP_JMP
(define emit-jnf      (make-jump-emitter 28))  ;; OP_JNF
(define emit-continue (make-jump-emitter 33))  ;; OP_CONTINUE

;; Emit a label definition in the bytecode stream.
;; Label tokens are chain-rules: (inner-label-token colon-char).
(define (emit-label target token)
    (write-string (token-text (car (token-text token))))
    (write-string ":")
    (write-string *newline*))

;; Emit a fixnum literal: OP_LIT_FIXNUM(2) + 8-byte value.
(define (emit-fixnum target token)
    (emit-op 2)
    (emit-quad-str (token-text token)))

;; Emit a char literal: OP_LIT_CHAR(3) + 4-byte value.
;; Char token is a chain-rule: (# \ char-value-token).
(define (emit-char target token)
    (define literal (car (cdr (token-text token))))
    (define literal-type (token-type literal))
    (define character
        (cond
            ((eq? literal-type '*newline*) 10)
            ((eq? literal-type '*space*)   32)
            ((eq? literal-type '*eof-char*) -1)
            ((eq? literal-type '*char*)
                (char->integer
                    (car (string->list (token-text literal)))))
            ((eq? literal-type '*hex-char*)
                (raise "hex-char not implemented" literal))))
    (emit-op 3)
    (emit-long-str (number->string character)))

;; Emit a string literal: OP_LIT_STRING(6) + 8-byte length + raw bytes.
;; String token is a chain-rule: (open-quote body-token close-quote).
(define (emit-string target token)
    (define body (token-text (car (cdr (token-text token)))))
    (emit-op 6)
    (emit-quad-str (number->string (string-length body)))
    (emit-string-bytes body))

;; Emit a symbol literal: OP_LIT_SYMBOL(7) + 8-byte length + raw bytes.
;; Symbol token is a chain-rule: (s-char string-token).
;; String token is a chain-rule: (open-quote body-token close-quote).
(define (emit-symbol target token)
    (define string-token (car (cdr (token-text token))))
    (define body (token-text (car (cdr (token-text string-token)))))
    (emit-op 7)
    (emit-quad-str (number->string (string-length body)))
    (emit-string-bytes body))
