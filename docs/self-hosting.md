# Self-Hosting Roadmap

This document describes the current state of the self-hosting effort, what is missing, and a realistic path to a fully self-hosted Scheme compiler.

## What "Self-Hosting" Means Here

A fully self-hosted Insomniac would mean: the Scheme compiler written in `src/core/` can compile itself — i.e., `insc` (the Scheme-compiled tokenizer/compiler) can take `insomniac-core.scm` as input and produce a working `insc`. The C bootstrap compiler (`insc-bootstrap`) would only be needed to produce the first generation.

There are two sub-goals:
1. **VM-hosted self-hosting** — `insc` emits internal assembly, which is assembled to bytecode and interpreted by the C VM. The VM, assembler, and runtime remain in C.
2. **Fully native self-hosting** — `insc-as` (the native assembler in Scheme) is complete enough to produce native x86-64 binaries, and `insc` targets it directly. No C VM is needed at runtime.

Goal 1 is the near-term realistic target. Goal 2 is longer-term.

## Current Status

| Component | Status | Notes |
|-----------|--------|-------|
| Scheme lexer | **Done** | `core/scheme/lexer.scm`, R7RS-compliant |
| Scheme parser | **Missing** | Nothing in `src/core/` parses s-expressions |
| IR / closure analysis | **Missing** | No intermediate representation |
| Tail call analysis | **Missing** | Need proper tail-position tracking |
| Emit internal assembly | **Missing** | The core compiler's main output |
| Assembler (C) | **Done** | `libinsomniac_asm` consumes internal assembly |
| VM (C) | **Done** | `libinsomniac_vm` interprets bytecode |
| Native assembler (Scheme) | **Partial** | `asm-core.scm` handles ~10% of instructions |
| `define-syntax` / macros | **Missing** | `parameterize`, `let`, `cond` are not syntax |
| Module system | **Missing** | No `define-library` / `import` / `export` |
| Floats | **Missing** | No FLONUM cell type in the VM |

## Phase 1: Scheme Parser

The `core/scheme/lexer.scm` produces a token stream. The next step is a parser that consumes this stream and produces an S-expression tree (or directly an IR).

The existing combinator framework (`core/lexer/matchers.scm`) can be used for parsing as well as lexing — the same `chain-rule`, `or-rule`, `*-rule` combinators work over a token stream. A parser combinator approach is idiomatic given what already exists.

Key forms to support:
- `define`, `lambda`, `if`, `begin`, `quote`, `set!`
- `let`, `let*`, `letrec` (can be desugared to `lambda`)
- `cond`, `and`, `or`, `when`, `unless` (can be desugared)
- `define-record-type`
- `(asm ...)` escape form (needed for primitives)
- `include`

## Phase 2: IR and Analysis

The bootstrap compiler uses a minimal IR (the instruction stream). A slightly richer IR would be useful for:

- **Tail position tracking** — which expressions are in tail position determines `tail_call_in` vs `call_in`
- **Free variable analysis** — not strictly needed for the current closure model (closures capture entire environments), but useful for optimization
- **Macro expansion** — `cond`, `let`, `and`, `or` are currently expanded during parsing in the bootstrap compiler; a proper macro expander in Scheme would be cleaner

The IR can closely mirror the bootstrap compiler's `ins_node_type` — a tagged union of node types. An association list of `(type . fields)` records implemented with `define-record-type` would work.

## Phase 3: Code Generator → Internal Assembly

The code generator walks the IR and emits the internal assembly language as text, then feeds it to the assembler.

The bootstrap compiler's `bootstrap_emit.c` is the reference implementation. The Scheme code generator needs to produce semantically identical output for equivalent inputs. The patterns are well-defined (see [Bootstrap Compiler](bootstrap-compiler.md)):

- Lambdas: `jmp skip / proc_label: arg-destructuring / body / swap ret / skip: / proc proc_label`
- Calls: build arg list with `() cons ... cons`, then `call_in` or `tail_call_in`
- `if`: `jnf true_label / false-branch / jmp done / true_label: true-branch / done:`
- Variables: `s"name" sym @` / `s"name" sym bind`

Once this phase is complete, `insc` can compile itself through the C VM pipeline. **This is the minimum viable self-hosting milestone.**

## Phase 4: The Self-Hosting Loop

With Phase 3 complete:

1. `insc-bootstrap` (C) compiles `insomniac-core.scm` → `insc` (generation 0)
2. `insc` (gen 0) compiles `insomniac-core.scm` → `insc` (generation 1)
3. `insc` (gen 1) compiles `insomniac-core.scm` → `insc` (generation 2)
4. Verify gen 1 == gen 2 (fixpoint test — the standard compiler self-hosting validation)

The C bootstrap compiler can be frozen at this point. Future changes to the language or compiler are made in `insomniac-core.scm` and bootstrapped via the previous generation.

## Phase 5: Native Code Generation (Optional / Long-term)

`asm-core.scm` is the beginning of a native x86-64 code generator. Completing it would mean:
- Implementing all ~80 VM opcodes as native x86-64 sequences
- Integrating with the GC (either calling the C GC via FFI, or implementing a GC in Scheme)
- Implementing the environment/closure model natively (currently in C VM)
- Handling the calling convention, exception handling, and continuations natively

This is a significant undertaking. The result would be a Scheme system with no C VM at runtime — the compiled binary would run natively.

A more pragmatic approach for native performance would be to keep the C VM but add a JIT compilation layer on top of the existing bytecode.

## Missing Language Features

Beyond the compiler infrastructure, several language features are absent:

**`define-syntax` / `syntax-rules`** — The standard library works around this by using procedures where syntax would normally be used (e.g., `param-wrap` instead of `parameterize`). Implementing hygienic macros is a significant but well-understood problem.

**Proper tail calls in `cond` / `let` / etc.** — The bootstrap compiler handles these as special cases. A macro expander that desugars them to `if`/`lambda` would make the core compiler simpler.

**Numeric tower** — Only fixnums exist. Adding flonums would require a new FLONUM cell type, GC registration, and arithmetic dispatch. Bignums are a larger undertaking.

**Module system** — No `define-library`, `import`, or `export`. Currently handled via `include` (textual inclusion). An R7RS module system would enable separate compilation and a proper namespace model.

**Proper `values` / `call-with-values`** — Multiple return values are not implemented. Can be simulated with lists but not transparently.

## Bootstrapping Strategy

The safest approach is to keep the C bootstrap compiler working and correct indefinitely. It is the "seed" compiler. The self-hosted compiler needs only to agree with it on the language semantics — not on implementation details.

Any time the self-hosted compiler is extended with a new feature (e.g., `define-syntax`), the bootstrap compiler does not need to be updated as long as the feature is implemented in Scheme code that the bootstrap compiler can compile. Only if a feature requires changes to the core language semantics (new cell types, new calling conventions) would the C bootstrap compiler need modification.
