# Standard Library

The standard library lives in `src/lib/`. Its entry point is `baselib.scm`, which is automatically injected before user code by the bootstrap compiler when `include_baselib=true`. All library code is compiled by `insc-bootstrap` and becomes part of the same bytecode blob as the user program.

## Injection Mechanism

The bootstrap compiler's `compile_file` / `compile_string` functions, when called with `include_baselib=true`, prepend `(include "lib/baselib.scm")` to the source before handing it to Flex. The `include` directive triggers Flex's include stack, transparently splicing the library source into the token stream.

## Preamble and Postamble

Before `baselib.scm` and after all code, the compiler wraps the output with:

**`src/lib/preamble.asm`** — raw assembly executed before user code:
- Binds `car`, `cdr`, `depth` as closures wrapping their VM opcodes
- Implements `prim-call/cc` entirely in assembly: saves the stack as a list, builds a continuation closure, calls the user procedure
- Binds `emergency-exit`, `gc-stats`, `command-line`

**`src/lib/postamble.asm`** — handles process exit.

## `baselib.scm` Structure

`baselib.scm` includes files in dependency order:

```scheme
(include "lib/dynamic.scm")
(include "lib/math.scm")
(include "lib/predicates.scm")
(include "lib/boolean.scm")
(include "lib/lists.scm")
(include "lib/vectors/core.scm")
(include "lib/vectors/vectors.scm")
(include "lib/vectors/byte-vectors.scm")
(include "lib/strings.scm")
(include "lib/records.scm")
(include "lib/loop.scm")
(include "lib/call-cc.scm")
(include "lib/parameter.scm")
(include "lib/error.scm")
(include "lib/ports/core.scm")
(include "lib/ports/binary.scm")
(include "lib/ports/textual.scm")
(include "lib/ports/memory.scm")
```

## Subsystem Details

### `dynamic.scm` — FFI

Provides Scheme-level access to shared libraries via the `import`, `call_ext`, and related VM opcodes:

```scheme
(define (import-bind lib-path func-name)
  ...)  ; returns a callable wrapping a C function

(define (import-factory lib-path)
  ...)  ; returns a procedure that creates bindings for all exports
```

Uses `(asm ...)` forms extensively to invoke `OP_IMPORT` and `OP_CALL_EXT`.

### `math.scm`

Thin Scheme wrappers over arithmetic opcodes. Also defines `min`, `max`, `abs`, `zero?`, `positive?`, `negative?`, `even?`, `odd?`.

### `predicates.scm`

Type predicates as one-line `(asm ...)` wrappers:
```scheme
(define (fixnum? x) (asm (x) fixnum?))
(define (string? x) (asm (x) string?))
; etc.
```

Also `equal?` — a recursive structural equality implemented in pure Scheme.

### `lists.scm`

Pure Scheme list operations: `cons`, `list`, `list?`, `length`, `reverse`, `list-copy`, `append`, `list-tail`, `list-ref`, `member`, `memq`, `memv`, `assoc`, `assq`, `assv`, `flatten`, `iota`.

### `vectors/`

- `core.scm` — `make-vector`, `vector-ref`, `vector-set!`, `vector-length`, `vector-copy`, `vector->list`, `list->vector`, `vector-fill!`
- `byte-vectors.scm` — `make-bytevector`, `bytevector-u8-ref`, `bytevector-u8-set!`, `bytevector-length`, `utf8->string`, `string->utf8`

### `strings.scm`

String operations: `string-length`, `string-ref`, `substring`, `string-append`, `string->list`, `list->string`, `string->number`, `number->string`, `string->symbol`, `symbol->string`, `string-copy`, `string-upcase`, `string-downcase`, `string=?`, `string<?`, etc.

### `records.scm`

Implements the `define-record-type` runtime. The key procedure is:

```scheme
(define (record-type-factory name fields)
  ...)
```

The bootstrap compiler emits a call to this with the record name (symbol) and field list. The factory allocates constructor, predicate, and accessor/mutator closures, and returns an alist of `(name . procedure)` pairs. The compiler then binds each pair in the current environment.

Record instances are VECTOR cells where element 0 is the type symbol.

### `loop.scm`

`for-each` and `map`, both supporting multiple lists:
```scheme
(define (for-each f . lists) ...)
(define (map f . lists) ...)
```

Multi-list versions use `prep-args` to build per-iteration argument lists.

### `call-cc.scm`

Wraps the primitive `prim-call/cc` with `dynamic-wind` support:

```scheme
(define dynamic-wind-stack '())

(define (dynamic-wind before thunk after)
  ...)

(define (call/cc f)
  ; wraps prim-call/cc to run after-thunks on continuation escape
  ...)

(define call-with-current-continuation call/cc)
```

The dynamic-wind stack is a plain Scheme list stored in a top-level binding.

### `parameter.scm`

```scheme
(define (make-parameter init) ...)
(define (param-wrap param value thunk) ...)  ; implements parameterize
```

Parameters are closures over a mutable binding. `parameterize` is not yet a syntax form — it is used procedurally via `param-wrap`. The file notes: *"We don't have define-syntax yet."*

### `error.scm`

```scheme
(define-record-type <error>
  (make-error message irritants)
  error?
  (message error-message)
  (irritants error-irritants))

(define (error message . irritants) ...)
(define (raise obj) ...)
(define (raise-continuable obj) ...)
(define (with-exception-handler handler thunk) ...)
(define (guard ...) ...)
```

Exception handling is built on the VM's `throw`/`continue`/`restore` opcodes. `with-exception-handler` registers a handler using `continue`, invokes the thunk, and uses `restore` to unregister on normal exit.

### `ports/`

A layered port system:
- `core.scm` — port record type, `current-input-port`, `current-output-port`, `current-error-port`
- `binary.scm` — `open-binary-input-file`, `read-u8`, `read-bytevector`, etc.
- `textual.scm` — `open-input-file`, `open-output-file`, `read-char`, `write-char`, `read-line`, `read`, `write`, `display`, `newline`, etc.
- `memory.scm` — `open-input-string`, `open-output-string`, `get-output-string` (in-memory ports)

## Primitive Wrapper Pattern

The `(asm ...)` form is used pervasively to expose VM opcodes:

```scheme
; One-argument primitive
(define (car x) (asm (x) car))

; Two-argument primitive
(define (cons a b) (asm (a b) cons))

; Mixed Scheme/assembly
(define (apply f args)
  (asm (f args)
    swap      ; reorder for tail_call_in
    tail_call_in))
```

## Test Framework

`src/lib/test/expect.scm` provides a minimal test framework used by `test/test_*.scm`:

```scheme
(define (expect description thunk expected)
  (let ((result (thunk)))
    (if (equal? result expected)
        (display "PASS: " description)
        (error "FAIL: " description result expected))))
```
