# Bytecode Format

The assembler (`src/libinsomniac_asm/`) transforms internal assembly text into a flat `uint8_t` byte array. This document describes the binary encoding.

## Opcode Space

Opcodes are single bytes (0–255). The `op` enum in `src/include/ops.h` is the authoritative definition. `OP_MAX_INS` is a sentinel marking the end of the valid opcode range. Currently around 80 opcodes are defined, leaving room for future expansion.

The opcode values are assigned by their position in the `ops.h` enum and must not be renumbered without regenerating all bytecode (there is no version field or negotiation).

## Instruction Encoding

Each instruction is one of three lengths:

### 1. No-operand instructions (1 byte)

The opcode byte alone. Examples: `OP_CONS`, `OP_CAR`, `OP_SWAP`, `OP_DUP`, `OP_DROP`, `OP_ADD`, `OP_RET`, `OP_CALL_IN`, `OP_TAIL_CALL_IN`, `OP_JIN`, all type predicates.

```
+--------+
| opcode |
+--------+
```

### 2. Fixed-width operand instructions

**OP_LIT_FIXNUM** (9 bytes):
```
+--------+--8 bytes, signed int64 LE--+
| opcode |         integer value       |
+--------+----------------------------+
```

**OP_LIT_CHAR** (5 bytes):
```
+--------+--4 bytes, uint32 LE--+
| opcode |     Unicode codepoint |
+--------+----------------------+
```

**Jump/call instructions** — `OP_JMP`, `OP_JNF`, `OP_CALL`, `OP_PROC`, `OP_CONTINUE` (9 bytes):
```
+--------+--8 bytes, signed int64 LE--+
| opcode |      relative offset        |
+--------+----------------------------+
```

The offset is relative to the byte immediately following the 8-byte operand field (i.e., the start of the next instruction). The assembler computes: `offset = label_address - (jump_address + 8)`.

### 3. Variable-length instructions

**OP_LIT_STRING** and **OP_LIT_SYMBOL**:
```
+--------+--8 bytes, int64 LE--+--N bytes--+
| opcode |   string length (N)  |   bytes   |
+--------+---------------------+-----------+
```

The string is stored as raw bytes (not null-terminated). Length is in bytes. For symbols, the bytes are the symbol name; symbols are interned at runtime.

## Reading Bytecode (VM perspective)

The VM dispatch loop in `vm_eval.c`:

```c
while (vm->env->ip < vm->env->length) {
    op_code = vm->env->code_ref[vm->env->ip];
    vm->env->ip++;
    (*vm->ops[op_code])(vm);
}
```

Each instruction handler reads additional bytes from `code_ref[ip]` as needed and advances `ip`. The `parse_int` utility reads 8 bytes little-endian:

```c
int64_t parse_int(vm_internal_type *vm) {
    int64_t result = 0;
    for (int i = 0; i < 8; i++) {
        result |= (int64_t)vm->env->code_ref[vm->env->ip++] << (8 * i);
    }
    return result;
}
```

## Bytecode in Native Executables

When producing a native binary (`run-asm.sh` / `compiler.c`), the bytecode is embedded in a `.s` (native assembly) file as a data section:

```asm
.section __DATA,__data
.global scheme_code
scheme_code:
    ; meta_obj_type header (mark=FIXED, so GC never moves it)
    .byte ...
    ; raw bytecode bytes
    .byte 0x01, 0x2a, 0x00, ...
```

The `FIXED` GC mark means the runtime's GC will never attempt to copy or free this embedded bytecode. The native binary links against `libinsomniac_runtime`, which contains `run_scheme()` — it finds `scheme_code`, creates a VM, and calls `vm_eval`.

## Bytecode Lifetime

Bytecode allocated at runtime (via `gc_alloc`) is a GC-managed blob with a type registered as an untyped byte array (no interior pointers). Bytecode embedded in native executables is marked `FIXED` and is never moved or freed.

## Debugging Information

Debug info is stored separately from the bytecode, as an array of `debug_range_type` records:

```c
typedef struct {
    int start;      // byte offset in code_ref
    int end;        // byte offset (exclusive)
    int line;
    int column;
    int file;       // index into file name table
} debug_range_type;
```

This is built by the assembler from `.file` directives and attached to the assembled code object. The VM uses it for error reporting and stack traces.
