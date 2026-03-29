# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Insomniac is a self-hosting Scheme compiler targeting x86-64 (and arm64 on Apple Silicon). It compiles Scheme source to a custom assembly language, assembles that to bytecode, and either interprets it via a stack-based VM or links it into a native executable. The project is bootstrapped in C (Bison/Flex parser, code generator) with the goal of becoming fully self-hosting via the Scheme compiler in `src/core/`.

## Build

Requires Homebrew bison on macOS (`brew install bison`) -- the system bison 2.3 is too old. CMake auto-detects Homebrew bison.

```bash
# Initial setup (creates build/ directory, runs cmake)
./setup.sh

# Build
cd build && make

# Run tests
cd build && ctest
```

Two main executables are produced in `build/src/`:
- **insc-bootstrap** -- the compiler (Scheme source -> assembly/bytecode)
- **insomniac** -- the runtime VM (executes bytecode)

## Running Scheme programs

```bash
# Compile + run via VM (bytecode mode, temp file cleaned up)
./run.sh program.scm

# Compile to native executable (assembly -> object -> linked binary)
./run-asm.sh program.scm    # produces ./runme
```

## Architecture

### Compilation pipeline

```
Scheme (.scm)
  -> Flex/Bison lexer+parser (src/libinsomniac_bootstrap/{lexer.l,scheme.y})
  -> Instruction stream (AST of ins_node_type nodes)
  -> Code generator (bootstrap_emit.c) emits custom assembly text
  -> Assembler (libinsomniac_asm/) produces bytecode
  -> Either: VM interprets bytecode (main.c)
     Or:     compiler.c wraps bytecode in platform asm -> as -> ld -> native binary
```

### Key libraries (all under src/)

| Library | Purpose |
|---------|---------|
| `libinsomniac_bootstrap` | Bison/Flex parser + code generator; builds instruction stream from Scheme source and emits assembly |
| `libinsomniac_asm` | Assembles custom assembly text into bytecode arrays |
| `libinsomniac_vm` | Stack-based bytecode VM; dispatch table of ~120 opcodes in `libinsomniac_vm_instructions/` |
| `libinsomniac_gc` | Garbage collector (mark-sweep with copying); type-registered -- GC learns object layout via `gc_register_type`/`gc_register_pointer` |
| `libinsomniac_hash` | Generic hash table (string-keyed and pointer-keyed variants) |
| `libinsomniac_buffer` | Elastic byte buffer with FILE* interface |
| `libinsomniac_runtime` | Runtime support linked into native executables |

### Object system (cell.h)

Tagged union: FIXNUM, BOOL, CHAR, STRING, SYMBOL, PAIR, VECTOR, BYTE_VECTOR, RECORD, CLOSURE, LIBRARY, EMPTY. Opcodes defined in `ops.h`.

### Self-hosting compiler (src/core/)

Scheme-in-Scheme compiler being developed toward full self-hosting. Entry point: `insomniac-core.scm`. Contains its own lexer (`core/lexer/`), Scheme parser (`core/scheme/`), and assembly code generator targeting x86-64 (`core/asm/target/`).

### Standard library (src/lib/)

`baselib.scm` is the entry point; includes lists, strings, vectors, records, math, call-cc, error handling, ports, etc. Assembly preamble/postamble in `preamble.asm`/`postamble.asm`.

### Tests

- C tests: `test/test_hash.c`
- Scheme tests: `test/test_*.scm` (compiled via `INSC_TARGET` CMake macro, run via CTest)
- Assembly test programs: `asm/*.asm`

### CMake macros

`INSC_TARGET(Name Input Output)` in `CMakeIncludes.txt` -- compiles a .scm file to an executable by invoking insc-bootstrap, then assembling and linking the output. Used for both test targets and production builds.

## Current branch: cheney

Active work on a Cheney-style copying garbage collector (replacing/augmenting the mark-sweep collector in `libinsomniac_gc`).
