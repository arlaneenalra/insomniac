# Bootstrap Compiler

The bootstrap compiler (`src/libinsomniac_bootstrap/`) is a C-based Scheme-to-assembly compiler. It is the current production compiler used to build all Scheme targets, including the nascent self-hosted compiler in `src/core/`. The produced executable is `build/src/insc-bootstrap`.

## Pipeline

```
Scheme source text
  -> Flex lexer + Bison parser   (lexer.l, scheme.y)
  -> Instruction stream IR       (ins_stream_type)
  -> emit_stream()               (bootstrap_emit.c)
  -> Internal assembly text      (buffer_type)
  -> Assembler                   (libinsomniac_asm)
  -> Bytecode
```

## Lexer and Parser

**`lexer.l`** — A Flex lexer that tokenizes Scheme. Supported token classes:
- Integers (`FIXED_NUMBER`)
- Strings, characters, boolean literals
- Symbols (`AST_SYMBOL`)
- Keywords: `define`, `lambda`, `if`, `cond`, `let*`, `and`, `or`, `set!`, `begin`, `quote`, `include`, `asm`, `define-record-type`
- Parentheses, dot, quasiquote, unquote

The lexer handles file inclusion via Flex's `include` stack: when it sees `(include "file")`, it pushes the new file onto the Flex input stack and resumes from there. This is how `baselib.scm` is injected — the driver calls `compile_file` with `include_baselib=true`, which prepends `(include "lib/baselib.scm")` before parsing the user's code.

**`scheme.y`** — A Bison grammar. The grammar builds the instruction stream IR directly during reduction; there is no separate AST phase.

## Instruction Stream IR

The IR is a **doubly-linked list** of `ins_node_type` nodes, not a tree. Each node has:

```c
typedef struct ins_node {
    ins_node_type_enum type;   // what kind of node
    ins_value_type value;      // union: string, stream, two_stream
    struct ins_node *next;
    struct ins_node *prev;
    char *file;                // source location
    int line;
    int column;
} ins_node_type;
```

Node types:

| Type | Value | Meaning |
|------|-------|---------|
| `STREAM_LITERAL` | `char*` | A bare assembly token (number, `#t`, `()`, etc.) |
| `STREAM_STRING` | `char*` | A string literal |
| `STREAM_SYMBOL` | `char*` | A symbol literal |
| `STREAM_OP` | `char*` | A raw assembly opcode mnemonic |
| `STREAM_LOAD` | `ins_stream_type*` | Variable read — child is the name stream |
| `STREAM_QUOTED` | `ins_stream_type*` | `quote` — child is the datum stream |
| `STREAM_ASM` | `ins_stream_type*` | `(asm ...)` escape form |
| `STREAM_COND` | `ins_stream_type*` | `cond` expression |
| `STREAM_AND` | `ins_stream_type*` | `and` expression |
| `STREAM_OR` | `ins_stream_type*` | `or` expression |
| `STREAM_BIND` | `two_stream_type` | `define` / `let` binding — two children: name, value |
| `STREAM_STORE` | `two_stream_type` | `set!` — two children: name, value |
| `STREAM_IF` | `two_stream_type` | `if` — two children: branches (condition is a third pointer) |
| `STREAM_MATH` | `two_stream_type` | Arithmetic/comparison operation |
| `STREAM_LAMBDA` | `two_stream_type` | `lambda` — two children: formals, body |
| `STREAM_CALL` | `two_stream_type` | Function application |
| `STREAM_LET_STAR` | `two_stream_type` | `let*` |

The `two_stream_type` struct holds two child streams plus a `char*` name field used for `STREAM_BIND`, `STREAM_MATH`, and `STREAM_IF` (the condition is the name field in `STREAM_IF`).

## Code Generator (`bootstrap_emit.c`)

`emit_stream(stream, buffer, allow_tail_call)` walks the IR and writes textual assembly into a `buffer_type`. Label generation uses a global counter via `gen_label()` producing `_label_N`.

Key emission patterns:

### Variable Load (`STREAM_LOAD`)
```asm
s"varname" sym  @
```

### Variable Bind (`STREAM_BIND`)
Emit value, then:
```asm
s"varname" sym  bind
```

### Variable Store (`STREAM_STORE`)
Emit value, then:
```asm
s"varname" sym  !
```

### If expression (`STREAM_IF`)
```asm
<condition>
jnf  _label_true
<false branch>
jmp  _label_done
_label_true:
<true branch>
_label_done:
```
Both branches are emitted with the same `allow_tail_call` flag as the surrounding context.

### Lambda (`STREAM_LAMBDA`)
```asm
jmp  _label_skip        ; skip over function body

_label_proc:
  ; destructure arg list into named bindings:
  dup  s"a" sym  bind   ; first arg
  cdr  dup  s"b" sym  bind   ; second arg
  ...
  drop                  ; discard rest
  <body with allow_tail_call=true>
  swap ret

_label_skip:
proc _label_proc        ; leave closure on stack
```

Variadic lambdas (rest parameter) omit the final `drop` and bind the remainder of the arg list.

### Function Call (`STREAM_CALL`)
```asm
()                      ; start arg list
<eval argN>
cons
...
<eval arg1>
cons                    ; args are (arg1 arg2 ... argN)
<eval function>
call_in                 ; or tail_call_in in tail position
```

### Tail Calls

The `allow_tail_call` flag is threaded through `emit_stream`. A call is emitted as `tail_call_in` (instead of `call_in`) when the flag is true. The flag is set to true for:
- The last expression in a `begin`-sequence or lambda body
- Both branches of an `if` when the `if` itself is in tail position
- The body of a `let*` binding

### Let* (`STREAM_LET_STAR`)

`let*` is compiled as a series of `define` bindings followed by the body, not as a separate lambda call.

### Cond (`STREAM_COND`)

Expanded into nested `if` chains during emission.

### And / Or

`and` and `or` are short-circuit: each clause is emitted with a conditional jump to the exit.

### Define-record-type

Records are implemented at runtime via the `record-type-factory` procedure (defined in `src/lib/records.scm`). The compiler emits a call to `record-type-factory` with the record name and field specs as a quoted list; the factory returns an alist of `(name . closure)` pairs. The compiler then emits a loop that destructures this alist and binds each entry.

### The `(asm ...)` Form (`STREAM_ASM`)

```scheme
(asm (arg1 arg2) raw-token1 (scheme-expr) raw-token2 ...)
```

Arguments are evaluated first and bound in a temporary environment. The body alternates between:
- Bare tokens → emitted as raw assembly
- Parenthesized sub-expressions → evaluated as Scheme (their results land on the stack)

This is the primary mechanism for exposing VM instructions to Scheme code.

## Preamble and Postamble

The driver (`bootstrap_preamble.c`) wraps emitted assembly between the contents of `src/lib/preamble.asm` and `src/lib/postamble.asm`.

**`preamble.asm`** sets up the initial runtime environment before user code runs:
- Binds `car`, `cdr`, `set!`, `depth` as closures wrapping the corresponding opcodes
- Implements `prim-call/cc` at the assembly level by saving and restoring the entire stack
- Binds `emergency-exit`, `gc-stats`, `command-line`

**`postamble.asm`** handles program exit, invoking the registered exit code.

## GC Protection During Compilation

The bootstrap compiler calls `gc_protect()` before parsing and `gc_unprotect()` after. This prevents GC sweeps during compilation, avoiding stale-pointer issues with the C data structures that hold the IR nodes.

## Entry Points

```c
// Compile a Scheme file to bytecode
asm_result_type compile_file(char *filename, bool include_baselib);

// Compile a Scheme string to bytecode
asm_result_type compile_string(char *source, bool include_baselib);
```

Both return an `asm_result_type` containing the assembled bytecode and debug info, ready for the VM.
