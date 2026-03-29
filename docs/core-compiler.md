# Core Scheme Compiler

`src/core/` contains the nascent self-hosted Scheme compiler — a Scheme program that will eventually replace the C bootstrap compiler (`insc-bootstrap`). It is compiled and run on the Insomniac VM via the `INSC_TARGET` CMake macro, producing two self-hosted executables: `insc` (Scheme tokenizer) and `insc-as` (native assembler).

## What Exists Today

### Entry Point: `insomniac-core.scm`

The main program. Currently it:
1. Parses the command-line arguments to get an input file path.
2. Opens the file and wraps it in a character stream.
3. Runs the Scheme lexer over the stream.
4. Prints each token.

It is essentially a **Scheme tokenizer** in production form. No parsing, no IR, no code generation.

### Lexer Framework (`core/lexer/`)

A combinator-based lexer framework entirely in Scheme. This is the most complete and polished component.

**`stream.scm`** — Character stream with pushback:
```scheme
(define (make-stream port) ...)
(define (stream-next! s) ...)     ; read one char, advance
(define (stream-peek s) ...)      ; read without advancing
(define (stream-unget! s ch) ...) ; push char back
```

**`matchers.scm`** — PEG-style matching combinators:

| Combinator | Description |
|------------|-------------|
| `(rule name pattern action)` | Define a named rule |
| `(chain-rule r1 r2 ...)` | Sequential composition (all must match) |
| `(or-rule r1 r2 ...)` | Ordered choice (first match wins) |
| `(*-rule r)` | Kleene star (zero or more) |
| `(+-rule r)` | One or more |
| `(?-rule r)` | Optional |
| `(not-rule r)` | Negative lookahead |
| `(char-rule ch)` | Match exact character |
| `(str-rule str)` | Match exact string |
| `(set-rule chars)` | Match any character in set |
| `(range-rule lo hi)` | Match character in Unicode range |
| `(eof-rule)` | Match end of input |
| `(any-rule)` | Match any single character |

Each combinator takes a stream and returns either a match result (list of consumed chars/tokens) or `#f` on failure.

**`token.scm`** — Token records and lexer infrastructure:
```scheme
(define-record-type <token>
  (make-token type value line column)
  token?
  (type token-type) (value token-value)
  (line token-line) (column token-column))

(define (make-lexer rules stream) ...)        ; builds a token stream
(define (filter-token-stream pred ts) ...)    ; drop unwanted tokens
```

**`core.scm`** — Base rules: whitespace, line endings.

### Scheme Lexer (`core/scheme/lexer.scm`)

A complete R7RS-compliant Scheme lexer built on the combinator framework. Token types produced:

| Token type | Examples |
|-----------|---------|
| `identifier` | `foo`, `+`, `list->vector`, `set!` |
| `boolean` | `#t`, `#f`, `#true`, `#false` |
| `integer` | `42`, `#xFF`, `#b1010`, `#o17` |
| `float` | `3.14`, `1e10` (tokenized but VM has no float type) |
| `character` | `#\a`, `#\space`, `#\newline`, `#\x41` |
| `string` | `"hello world"` |
| `open` | `(` |
| `close` | `)` |
| `vector-open` | `#(` |
| `bytevector-open` | `#u8(` |
| `quote` | `'` |
| `quasiquote` | `` ` `` |
| `unquote` | `,` |
| `unquote-splicing` | `,@` |
| `dot` | `.` |
| `comment` | `;...` (filtered out) |
| `block-comment` | `#| ... |#` (nested, filtered out) |
| `datum-comment` | `#;` |
| `eof` | end of input |

All numeric radices (`#b`, `#o`, `#d`, `#x`) are handled. Nested block comments are properly tracked.

### Native Assembler (`asm-core.scm`)

A Scheme-written assembler that reads the **internal assembly language** (the same textual format the bootstrap compiler emits) and emits **native x86-64 machine code**. This is the beginning of a direct compilation path that bypasses the VM.

**`asm/lexer.scm`** — Lexer for the internal assembly language, built on the same combinator framework. Tokenizes all assembly mnemonics, labels, literals, and directives.

**`asm/target/core.scm`** — Target-independent assembler framework:
```scheme
(define-record-type <target>
  (make-target name emit-preamble emit-postamble ...)
  ...)
```

Defines the interface a target must implement.

**`asm/target/emitter.scm`** — Instruction dispatch table mapping assembly token types to emission handlers:
- `fixnum` → emit literal fixnum handling code
- `string` → emit string allocation
- `char` → emit character literal
- `drop`, `call`, `jmp` → emit corresponding native code
- `write`, `out` → emit I/O
- labels → emit label definitions

**`asm/target/mac-x64.scm`** — macOS x86-64 target:
- Defines ABI: argument/return registers, calling convention
- **Preamble**: Uses `mmap` syscall to allocate a raw heap (no GC integration yet)
- **Postamble**: Emits process exit
- Label generation: Uses the same `_label_N` scheme as the bootstrap compiler
- Emits GNU assembler syntax (`.s` files)

**`asm/target/x64.scm`** — Linux x86-64 target stub. Currently empty (just a header comment).

## What Is Missing

| Component | Status |
|-----------|--------|
| Scheme lexer | Complete |
| Scheme parser | Missing |
| AST / IR | Missing |
| Semantic analysis (closures, tail calls, defines) | Missing |
| Code generator → internal assembly | Missing |
| Code generator → native x86-64 (via asm-core) | Partial (~10% of instructions) |
| Macro system (`define-syntax`) | Missing |
| Module system (`define-library`) | Missing |

## Relationship to Bootstrap Compiler

The bootstrap compiler (`insc-bootstrap`) and the core compiler share the same internal assembly language as an intermediate representation. The bootstrap compiler emits it from C; the core compiler will eventually emit it from Scheme. The assembler (`libinsomniac_asm`) remains in C and consumes the same format regardless of which compiler produced it.

The two compilers are intentionally parallel in design — the core compiler is being built to be semantically equivalent to the bootstrap compiler, not to replace a different design.

## Self-Hosted Build

The core compiler executables are built by `INSC_TARGET` in `CMakeLists.txt`:

```cmake
INSC_TARGET(insc src/core/insomniac-core.scm insc)
INSC_TARGET(insc-as src/core/asm-core.scm insc-as)
```

This means:
1. `insc-bootstrap` compiles `insomniac-core.scm` to internal assembly.
2. `libinsomniac_asm` assembles that to bytecode.
3. `compiler.c` wraps the bytecode in a `.s` native assembly file.
4. The system assembler and linker produce the `insc` native binary.
5. `insc` runs on the VM (via `libinsomniac_runtime`) but is a native executable.

Stage 0 bootstrap is via the C compiler. Stage 1 would be `insc` compiling itself.
