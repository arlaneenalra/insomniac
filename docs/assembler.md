# Assembler

The assembler (`src/libinsomniac_asm/`) transforms internal assembly text into a flat bytecode array. It is a two-pass assembler: a single scanning pass that emits bytecodes and records forward references, followed by a jump-fixup pass that patches relative offsets once all label addresses are known.

## Source Files

| File | Purpose |
|------|---------|
| `asm_core.c` | Main assembler logic: scanning loop, label resolution, jump fixup |
| `asm_types.c` | Type definitions and allocation helpers |
| `lexer.l` | Flex scanner for the assembly language |

## The Flex Scanner

The scanner in `lexer.l` is elegant: assembly mnemonics are mapped **directly** to their opcode integer values as token types. This means the scanner returns the opcode byte as the token — no separate keyword-to-opcode lookup table is needed. The scanning loop simply reads the token and switches on its value.

Special token types (not opcodes):
- `LABEL_TOKEN` — a `name:` label definition
- `STRING_START_TOKEN` / `SYMBOL_START_TOKEN` — begin of a string/symbol literal
- `DIRECTIVE_FILE` — a `.file "name" line col` source map directive
- `INTEGER_TOKEN` — a bare integer literal

## Pass 1: Scanning

`asm_string(text, length)` is the main entry point. It feeds the text to the Flex scanner and processes tokens in a loop:

**Simple (no-operand) instructions:**
Emit the opcode byte directly to the output buffer.

**OP_LIT_FIXNUM:**
Parse the integer text, emit opcode + 8-byte LE int64.

**OP_LIT_CHAR:**
Parse the character literal (handles `#\space`, `#\newline`, `#\tab`, `#\nul`, and Unicode escapes), emit opcode + 4-byte LE uint32 codepoint.

**OP_LIT_STRING / OP_LIT_SYMBOL:**
Emit opcode, then scan string body tokens until the closing `"`. Emit the body as an 8-byte length prefix followed by the raw bytes.

**Jump instructions** (`OP_JMP`, `OP_JNF`, `OP_CALL`, `OP_PROC`, `OP_CONTINUE`):
1. Record current buffer position and the target label name in a `jump_type` linked list entry.
2. Emit the opcode byte.
3. Emit 8 zero bytes as a placeholder for the relative offset.

**LABEL_TOKEN:**
Record `(label_name -> current_buffer_offset)` in the labels hashtable.

**DIRECTIVE_FILE:**
Parse filename, line, and column. Append a `debug_state_type` entry to the debug chain, recording the current buffer offset and source location. The VM uses these to map bytecode addresses back to source positions.

## Pass 2: Jump Fixup

After the scan is complete, the buffer is extracted as a `uint8_t*` array. `rewrite_jumps` iterates the jump list:

```
for each jump:
    label_addr = hashtable_lookup(labels, jump.label_name)
    jump_addr  = jump.operand_offset   // points to the 8 bytes after the opcode
    offset     = label_addr - jump_addr - 8
    write int64_LE(offset) into code_ref[jump_addr]
```

The `-8` accounts for the fact that the relative offset is measured from the byte immediately after the operand field (i.e., the start of the next instruction), consistent with how the VM advances `ip` before reading the operand.

## Label Scoping

All labels are global within a single assembly unit. There is no namespacing, no section model, and no linker — every Scheme program is compiled to a single flat assembly file assembled in one shot. The bootstrap compiler generates unique labels using a global counter (`gen_label()` produces `_label_N`).

Forward references work correctly: the scan emits a placeholder, the label is recorded when encountered, and fixup patches the placeholder afterward. Undefined labels cause an assertion failure.

## Debug Information

The assembler builds a linked list of `debug_state_type` records during scanning. After assembly, this is flattened into an array of `debug_range_type` structs:

```c
typedef struct {
    int start;    // start byte offset in code_ref
    int end;      // end byte offset (exclusive)
    int line;
    int column;
    int file;     // index into interned filename table
} debug_range_type;
```

File names are interned in a hashtable keyed by string; each unique file name gets an integer index. The debug array and file name table are attached to the assembled code object and passed to the VM for error reporting.

## Output

`asm_string` returns an `asm_result_type`:

```c
typedef struct {
    uint8_t *code;        // flat bytecode array
    size_t   length;      // byte count
    debug_range_type *debug;
    int       debug_count;
    char    **files;      // interned file name table
    int       file_count;
} asm_result_type;
```

This is consumed directly by the VM or wrapped in a native `.s` file for linking into a standalone executable.

## Limitations

- **No relocatable object format.** All code is position-independent by construction (relative jumps), so relocation is unnecessary.
- **No separate linking step.** All Scheme code for a program, including the standard library, is assembled in a single pass into one bytecode blob.
- **No optimization.** The assembler emits exactly what it receives; peephole optimization, dead code elimination, etc. are not performed.
- **Single compilation unit.** There is no separate compilation or incremental rebuilding at the assembly level.
