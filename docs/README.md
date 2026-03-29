# Insomniac Scheme — Architecture Documentation

Insomniac is a self-hosting Scheme compiler targeting x86-64 (and arm64 on Apple Silicon). It compiles Scheme source to a custom stack-based assembly language, assembles that to bytecode, and either interprets it via a VM or links it into a native executable. The project is bootstrapped in C with the goal of becoming fully self-hosting via the Scheme compiler in `src/core/`.

## Documents

- [Assembly Language](assembly-language.md) — the internal stack-based assembly format, instruction set, and syntax
- [Bytecode Format](bytecode.md) — binary encoding of instructions and operands
- [Bootstrap Compiler](bootstrap-compiler.md) — Bison/Flex parser, instruction stream IR, and assembly emitter
- [Assembler](assembler.md) — two-pass assembler: scanning, label resolution, jump fixup
- [Virtual Machine](vm.md) — dispatch, stack, environments, calling convention, closures, continuations
- [Garbage Collector](gc.md) — Cheney semi-space copying collector, type registration, root tracking
- [Object System](object-system.md) — tagged union cell types, heap layout, GC integration
- [Standard Library](stdlib.md) — baselib structure, primitive wrappers, key subsystems
- [Core Scheme Compiler](core-compiler.md) — nascent self-hosted compiler: lexer, native assembler
- [Self-Hosting Roadmap](self-hosting.md) — what exists, what is missing, realistic path forward
- [Closures, Environments, and `adopt`](closures-and-environments.md) — how closures differ from standard CS, the triple role of CLOSURE cells, and how `adopt` enables scope surgery

## Compilation Pipeline

```
Scheme (.scm)
  -> Flex/Bison parser          [src/libinsomniac_bootstrap/]
  -> Instruction stream IR
  -> Assembly emitter           [bootstrap_emit.c]
  -> Internal assembly text
  -> Assembler                  [src/libinsomniac_asm/]
  -> Bytecode (flat byte array)
  -> Either:
       VM interprets bytecode   [src/libinsomniac_vm/]
     Or:
       Wrapped in .s data section -> as -> ld -> native binary
```

## Key Source Locations

| Path | Purpose |
|------|---------|
| `src/include/ops.h` | Opcode enum — single source of truth for all VM instructions |
| `src/include/cell.h` | Object/cell type definitions |
| `src/include/emit.h` | Bytecode emission macros |
| `src/libinsomniac_bootstrap/` | Bison/Flex parser + code generator |
| `src/libinsomniac_asm/` | Assembler (text assembly -> bytecode) |
| `src/libinsomniac_vm/` | Bytecode VM and instruction handlers |
| `src/libinsomniac_gc/` | Cheney copying garbage collector |
| `src/libinsomniac_hash/` | Hash table (string-keyed and pointer-keyed) |
| `src/libinsomniac_buffer/` | Elastic byte buffer with FILE* interface |
| `src/libinsomniac_runtime/` | Runtime support linked into native executables |
| `src/lib/` | Standard library (Scheme source, `baselib.scm` is entry point) |
| `src/core/` | Nascent self-hosted Scheme compiler |
