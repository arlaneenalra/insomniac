# Internal Assembly Language

Insomniac uses a custom stack-based textual assembly language as the intermediate representation between the Scheme compiler and the bytecode assembler. The bootstrap compiler (`insc-bootstrap`) emits this format; the assembler (`src/libinsomniac_asm/`) consumes it.

## Syntax

The assembly is a flat sequence of whitespace-separated tokens. Comments begin with `;` and run to end of line. There are no registers — all operations push and pop a single operand stack.

```asm
; Compute (+ 1 2) and print it
1
2
+
out
()
ret
```

Labels are defined with a trailing colon and referenced by name in jump/call instructions:

```asm
my_func:
  dup
  +
  ret

proc my_func   ; leaves closure on stack
```

Debug directives associate source locations with byte ranges:

```asm
.file "foo.scm" 10 3
```

## Instruction Reference

### Literals

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `N` (integer) | `-- N` | Push fixnum literal |
| `#t` | `-- #t` | Push boolean true |
| `#f` | `-- #f` | Push boolean false |
| `()` | `-- ()` | Push empty list |
| `#\<char>` | `-- char` | Push character literal (e.g. `#\a`, `#\space`, `#\newline`) |
| `"string"` | `-- str` | Push string literal |
| `s"symbol"` | `-- sym` | Push symbol literal |
| `sym` | `str --  sym` | Convert TOS string to symbol |

### Stack Manipulation

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `dup` | `a -- a a` | Duplicate top of stack |
| `drop` | `a --` | Discard top of stack |
| `swap` | `a b -- b a` | Swap top two elements |
| `rot` | `a b c -- b c a` | Rotate top three elements |
| `depth` | `-- n` | Push current stack depth |

### List Operations

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `cons` | `car cdr -- pair` | Allocate a pair |
| `car` | `pair -- car` | First element of pair |
| `cdr` | `pair -- cdr` | Rest of pair |
| `set-car` | `pair val --` | Mutate car of pair |
| `set-cdr` | `pair val --` | Mutate cdr of pair |

### Vectors and Records

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `vector` | `n -- vec` | Allocate vector of length n |
| `vector-u8` | `n -- bvec` | Allocate byte-vector of length n |
| `record` | `n -- rec` | Allocate record of length n |
| `idx@` | `vec i -- val` | Read vector element at index i |
| `idx!` | `vec i val --` | Write vector element at index i |
| `vec-len` | `vec -- n` | Length of vector/byte-vector/record/string |
| `str->u8` | `str -- bvec` | Convert string to byte-vector (UTF-8) |
| `u8->str` | `bvec -- str` | Convert byte-vector (UTF-8) to string |
| `int->char` | `n -- char` | Convert codepoint integer to character |
| `char->int` | `char -- n` | Convert character to codepoint integer |

### Variable Binding

Variable storage is lexically scoped via the environment chain. Each environment is a hashtable; lookup walks parent environments.

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `bind` | `sym val --` | Bind symbol to value in current environment |
| `@` | `sym -- val` | Read symbol's value from environment chain |
| `!` | `sym val --` | Set symbol's value in environment chain (set!) |

In practice the bootstrap compiler emits string literals followed by `sym` to convert them, but symbol literals (`s"..."`) are used directly.

### Arithmetic

All arithmetic operates on fixnums. There is currently no floating-point support.

| Mnemonic | Stack effect |
|----------|-------------|
| `+` | `a b -- (a+b)` |
| `-` | `a b -- (a-b)` |
| `*` | `a b -- (a*b)` |
| `/` | `a b -- (a/b)` |
| `%` | `a b -- (a%b)` |

### Comparison and Logic

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `=` | `a b -- bool` | Numeric equality |
| `<` | `a b -- bool` | Numeric less-than |
| `>` | `a b -- bool` | Numeric greater-than |
| `eq` | `a b -- bool` | Object identity (`eq?`) |
| `not` | `a -- bool` | Boolean negation |

### Type Predicates

Each predicate pops one value and pushes `#t` or `#f`.

`fixnum?`, `bool?`, `char?`, `string?`, `symbol?`, `vector?`, `vector-u8?`, `record?`, `pair?`, `null?`, `proc?`, `self?`

### Control Flow

All jump/call instructions take a symbolic label as their operand. The assembler resolves labels to signed relative offsets.

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `jmp label` | — | Unconditional jump |
| `jnf label` | `cond --` | Jump if not false (jump if truthy) |
| `call label` | — | Push return closure, push new child env, jump to label |
| `proc label` | `-- closure` | Create closure pointing to label (no jump) |
| `jin` | `closure --` | Jump indirect: restore closure's environment and jump to its IP |
| `call_in` | `closure --` | Call indirect: push return closure, then `jin` |
| `tail_call_in` | `closure --` | Tail call: `call_in` without pushing a new return closure |
| `ret` | `closure --` | Return: pop closure, restore its environment |
| `call_ext` | `fn args -- result` | Call external C function (for FFI) |

### Exception Handling

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `continue label` | — | Register label as exception handler in current environment |
| `throw` | `exn --` | Raise exception; walks env chain for nearest handler |
| `restore` | — | Clear exception handler in current environment |

When an exception is thrown, the handler receives a list `(message closure . objects)` on the stack.

### I/O and System

| Mnemonic | Stack effect | Description |
|----------|-------------|-------------|
| `out` | `val --` | Display value to stdout |
| `read` | `-- val` | Read a Scheme value from stdin |
| `write` | `val --` | Write value (with `write` quoting) |
| `open` | `path mode -- port` | Open file port |
| `close` | `port --` | Close port |
| `slurp` | `port -- str` | Read entire port contents |
| `asm` | `str -- bytecode` | Assemble a string of assembly text at runtime |
| `import` | `path -- lib` | Import a shared library (dlopen) |
| `gc-stats` | `-- str` | Push GC statistics string |
| `set-exit` | `code --` | Set process exit code |
| `nop` | — | No operation |
| `adopt` | — | Adopt current stack into parent environment |

### Directives

Directives are not opcodes — they control assembler behavior but emit no bytecode.

| Directive | Description |
|-----------|-------------|
| `.file "name" line col` | Associate subsequent bytecodes with source location |

## Calling Convention

Arguments are passed on the stack as a Scheme list. The callee receives a single list argument containing all values. The return value is left on the stack when `ret` is executed.

A typical call sequence (for `(f a b)`):
```asm
()          ; start arg list
<eval b>
cons
<eval a>
cons        ; arg list is (a b) on stack
<eval f>    ; push the closure
call_in     ; or tail_call_in for tail position
```

Inside the callee, the arg list is destructured with `dup car ... cdr car ... drop`:
```asm
my_func:
  dup car        ; first arg
  s"x" sym bind  ; bind as x
  cdr car        ; second arg
  s"y" sym bind  ; bind as y
  drop           ; discard rest of arg list
  ...
  swap ret       ; return value, restore caller
```

## The `(asm ...)` Escape Form

The Scheme `(asm args body...)` special form allows embedding raw assembly within Scheme code. Sub-expressions in parentheses are evaluated as Scheme and their values left on the stack; bare tokens are emitted as raw assembly instructions. This is how most standard library primitives are implemented:

```scheme
(define (car x) (asm (x) car))
(define (cons a b) (asm (a b) cons))
(define (+ a b) (asm (a b) +))
```
