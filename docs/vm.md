# Virtual Machine

The Insomniac VM (`src/libinsomniac_vm/`) is a stack-based bytecode interpreter. It executes the bytecode produced by the assembler. The produced executable is `build/src/insomniac`.

## Source Layout

```
src/libinsomniac_vm/
  vm.h / vm_internal.h       -- VM and environment type definitions
  vm_eval.c                  -- main dispatch loop
  vm_ops.c                   -- opcode table setup
  vm_util.c                  -- parse_int, parse_string, etc.
  vm_types.c                 -- GC type registration for VM objects
  libinsomniac_vm_instructions/
    op_*.c                   -- one or a few files per opcode group
```

## Dispatch Mechanism

The VM uses a **function-pointer table** indexed by opcode byte:

```c
typedef void (*fn_type)(vm_internal_type *vm);

typedef struct vm_internal {
    fn_type ops[256];    // dispatch table
    // ...
} vm_internal_type;
```

`setup_instructions()` in `vm_ops.c` populates the table. The dispatch loop in `vm_eval.c` is straightforward:

```c
while (vm->env->ip < vm->env->length) {
    uint8_t op_code = vm->env->code_ref[vm->env->ip];
    vm->env->ip++;
    (*vm->ops[op_code])(vm);
    vm->reg1 = vm->reg2 = vm->reg3 = 0;
}
```

Three temporary GC roots (`reg1`, `reg2`, `reg3`) are available to instruction handlers and are zeroed after each instruction to avoid retaining values across GC points.

## The Stack

The operand stack is a **GC-managed linked list of cons cells**, not a C array:

```
vm->stack_root -> (value_N . (value_N-1 . (... . ())))
```

Push creates a new cons `(value . old_root)` and updates `vm->stack_root`. Pop reads `car(stack_root)` and advances `stack_root` to `cdr(stack_root)`. Stack depth is tracked in `vm->depth`.

Because the stack is heap-allocated, it participates in GC naturally — the GC traces through the cons cells. This also means the entire stack can be saved and restored as a plain Scheme list, which is how `call/cc` is implemented.

## Environments

Each environment (`env_type`) is a GC-managed struct:

```c
typedef struct env {
    uint8_t  *code_ref;     // pointer to bytecode array
    size_t    length;       // bytecode length
    size_t    ip;           // instruction pointer
    hash_type *bindings;    // variable bindings (string -> object)
    struct env *parent;     // parent environment
    int       handler;      // 1 if an exception handler is registered
    size_t    handler_addr; // IP of handler (in this env's code_ref)
    // debug info (not GC-managed)
    debug_range_type *debug;
    int        debug_count;
    char     **files;
    int        file_count;
} env_type;
```

`push_env` creates a new child environment inheriting the parent's `code_ref`, `ip`, and `length`. The child starts with an empty bindings table. `pop_env` restores the parent (used during `ret`).

## Variable Lookup

- `op_read` (`@`): Walk `env->parent` chain searching for `symbol` in each env's `bindings`. Returns the first match. Error if not found.
- `op_bind` (`bind`): Insert into the **current** environment's bindings only.
- `op_set` (`!`): Walk the chain and mutate the first match. Error if not found (this is `set!`, not `define`).

## Closures

A closure is an `object_type` of type `CLOSURE` whose `value.closure` field points to an `env_type*`. The `OP_PROC` instruction:
1. Clones the current environment (deep-copies the env struct but shares the parent chain).
2. Sets the cloned env's `ip` to the target label.
3. Allocates a CLOSURE cell pointing to the cloned env.
4. Pushes the closure onto the stack.

The closure **captures the entire environment chain** at creation time, including all bindings visible at the point of `proc`. Mutation of bindings after closure creation is reflected in the closure (closures close over bindings, not values).

## Calling Convention

All arguments are passed as a single **Scheme list** on the stack. The calling sequence for `(f a b)`:

```
Caller pushes:  ()         ; empty list
                <b>
                cons        ; (b)
                <a>
                cons        ; (a b)
                <f>         ; the closure
                call_in
```

Inside the callee, the arg list is destructured manually:
```
my_func:
  dup car        ; first arg on stack
  s"x" bind     ; bind as x
  cdr dup car    ; second arg
  s"y" bind
  drop           ; discard rest
  <body>
  swap ret
```

`swap ret` at the end: `swap` brings the return closure to the top (it was saved below the result), `ret` restores the caller's environment.

## Call/Return Mechanics

### `OP_CALL label` (direct call)
1. Create a return closure capturing the current env at the current `ip`.
2. Push return closure onto stack.
3. `push_env` (new child env).
4. Jump to `label`.

### `OP_CALL_IN` (indirect call)
1. Pop the target closure from the stack.
2. Create return closure from current env, push it.
3. Clone the target closure's env.
4. Replace current env with the clone.
5. `push_env`.

### `OP_TAIL_CALL_IN` (tail call, no stack growth)
Same as `OP_CALL_IN` but does **not** push a new return closure. The existing return closure from the current call frame is preserved beneath the arguments, so the tail call reuses it. This enables proper tail recursion without unbounded stack growth.

### `OP_RET` (return)
1. Pop the return closure from the stack.
2. Restore that closure's environment as the current env.
(The result value was already left on the stack below the return closure by the `swap` before `ret`.)

### `OP_JIN` (jump indirect)
Jump to a closure without creating a return frame. Used internally.

## Continuations

`call/cc` is implemented **at the Scheme/assembly level** in `preamble.asm`, not in C. The implementation:

1. **`stack-save`** — A Scheme procedure that iterates the stack and builds a list of all values, then returns this list. Uses the `depth` opcode to know how many items are present.
2. **`call/cc`** — Takes a procedure `f`:
   - Saves the entire current stack to a list via `stack-save`.
   - Allocates a continuation closure that, when called with value `v`, will:
     - Empty the current stack.
     - Restore the saved stack from the list.
     - Push `v`.
     - Resume execution.
   - Calls `f` with the continuation closure.

This is a first-class continuation (escape continuation pattern). Re-invocable continuations work because the stack is a heap-allocated list that can be restored multiple times.

## Exception Handling

`OP_CONTINUE label` registers `label` as an exception handler in the current env (`env->handler = 1`, `env->handler_addr = label`).

`OP_THROW` — calls `handle_exception(vm)`:
1. Walk `env->parent` chain looking for an env with `handler = 1`.
2. Clone that env, disable its handler flag.
3. Set current env to the clone.
4. Push the exception value (packaged as a list `(message closure . irritants)`) onto the stack.
5. Jump to `handler_addr`.

`OP_RESTORE` — clear the exception handler on the current env.

## Symbol Interning

The VM maintains a global `symbol_table` (a string-keyed hashtable). `op_sym` (`sym` instruction) takes a string from the stack, looks it up in the symbol table, and either returns the existing interned symbol or creates a new one and registers it. This ensures `eq?` works correctly for symbols.

## FFI (`call_ext`)

External C functions are called via `OP_CALL_EXT`. The function pointer and argument list are on the stack. Arguments are passed as a Scheme list; the C function receives a `vm_internal_type*` and the arg list and pushes its result onto the VM stack. Libraries are loaded with `OP_IMPORT` (dlopen) and their function tables accessed via `OP_CALL_EXT`.

## VM State Summary

```c
typedef struct vm_internal {
    fn_type      ops[256];        // dispatch table
    env_type    *env;             // current environment
    object_type *stack_root;      // operand stack (list of cons cells)
    int          depth;           // stack depth
    object_type *reg1, *reg2, *reg3;  // per-instruction GC roots
    hash_type   *symbol_table;    // interned symbols
    gc_type     *gc;              // garbage collector
    // ... type handles for GC registration
} vm_internal_type;
```
