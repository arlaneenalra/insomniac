# Closures, Environments, and `adopt`

The terms "closure" and "proc" in Insomniac are related to their standard computer science meanings but are not identical. Understanding the differences is important for working with the VM's call mechanics and for understanding how `adopt` enables the FFI binding injection pattern.

## What a Closure Actually Is

In standard CS, a *closure* is a pair of (function code, captured lexical environment). In Insomniac, a CLOSURE cell is simply a **wrapped `env_type*`**:

```c
object_type {
    cell_type type;    // == CLOSURE
    value_type value;
        void *closure; // actually env_type*
}
```

An `env_type` is a **complete execution context**:

```c
struct env {
    uint8_t  *code_ref;     // pointer to bytecode
    size_t    length;       // bytecode length
    size_t    ip;           // instruction pointer (offset into code_ref)
    hashtable_type *bindings; // variables bound at this level
    env_type *parent;         // parent scope (for lookup chain)
    uint8_t   handler;        // exception handler registered?
    size_t    handler_addr;   // handler IP
};
```

A closure is not "function + captured env" — it is a **resumable snapshot of the entire VM execution state** at a specific point in the bytecode. Because of this, closures serve three distinct roles:

| Role | Created by | Used by |
|------|-----------|--------|
| Procedure (function value) | `proc label` | `call_in`, `tail_call_in`, `jin` |
| Return address | `call`, `call_in` | `ret` |
| Continuation | `proc` in `prim-call/cc` | `jin` |

There is no separate "return address" object — the VM pushes a CLOSURE onto the value stack before every call, and `ret` pops it.

## The `proc` Instruction

```
proc label  -- closure
```

`proc` **clones** the current `env_type` (sharing `bindings` and `parent` by pointer, but allocating a new struct), advances the clone's `ip` to `label`, and wraps it in a CLOSURE cell. Control does **not** transfer.

```c
// op_proc:
clone_env(vm, &env, vm->env, false);   // copy struct, share bindings/parent
env->ip += target;                      // point to the function body
clos->value.closure = env;
vm_push(vm, clos);
```

The resulting closure captures "the current scope, starting execution at this label." When it is later called, the callee's variable lookups walk the environment chain that existed at the point of `proc` — this is the lexical scoping.

## The `call` and `call_in` Instructions

`call label` creates a return closure differently from `proc`:

```c
// op_call:
clos->value.closure = vm->env;  // capture current env DIRECTLY, no clone
vm_push(vm, clos);              // push as return address
push_env(vm);                   // new empty child env
vm->env->ip += target;          // jump
```

There is no `clone_env` here — the return closure holds a **direct reference** to the live `vm->env`. This is safe because `ret` will `clone_env` the closure's env when restoring it, so the caller's env is never accidentally aliased.

`call_in` (indirect call through a closure) does `clone_env` the *target* closure's env before jumping into it:

```c
// op_call_in:
ret->value.closure = vm->env;              // return closure: direct ref
vm_push(vm, ret);
clone_env(vm, &new_env, clos->value.closure, false);  // fresh copy of target
vm->env = new_env;
push_env(vm);                              // child of the target's env
```

Cloning the target env ensures each activation of a closure gets its own `env_type` struct, so concurrent activations (or re-entrant calls) don't share mutable state in the header.

## The `ret` Instruction

```
ret  closure --
```

`ret` pops the return closure and restores it:

```c
// op_ret:
clone_env(vm, &new_env, clos->value.closure, false);
vm->env = new_env;
```

Again a `clone_env` — we get a fresh `env_type` struct pointing to the same `code_ref`, `ip`, `bindings`, and `parent` as the saved return address. No `pop_env` is needed; the entire current environment chain is simply replaced.

## The `jin` Instruction (Jump Indirect, Keep Scope)

`jin` is distinct from `ret` and `call_in`: it jumps to a closure's code location but **keeps the current lexical scope**:

```c
// op_jin:
env = vm->env;                                          // save current env
clone_env(vm, &new_env, clos->value.closure, false);   // go to closure's code
vm->env = new_env;
// override: keep current scope
vm->env->bindings = env->bindings;
vm->env->parent   = env->parent;
```

This is used in `preamble.asm` for the `env:` trampoline:

```asm
env:
    swap jin
```

`env` takes a lambda (closure) on the stack and `jin`s into it. The lambda's code runs, but variable lookups resolve in the environment at the point of `jin`, not the environment captured when the lambda was created. This allows lambdas to be "injected" into the current scope rather than executing in their own captured scope.

## Summary: `proc` vs Standard "Closure"

| | Standard CS closure | Insomniac `proc` result |
|---|---|---|
| What it captures | (code, lexical env snapshot) | A cloned `env_type` (code_ref, ip, bindings, parent) |
| What "calling" it does | Runs function body in captured env | `clone_env` the saved env, `push_env` a child, run from saved ip |
| Return address | Implicit on call stack | Explicit CLOSURE pushed onto value stack |
| Continuation support | Not inherent | Direct: save the stack + a `proc` = a first-class continuation |

---

## The `adopt` Instruction

`adopt` is the most novel instruction in the VM. It takes two closures and produces a third:

```
adopt  par chld -- adopted
```

- **`chld`** provides the **code location** (code_ref, ip, length, debug info)
- **`par`** provides the **variable scope** (bindings hashtable, parent chain)

```c
// op_adopt:
clone_env(vm, &env, chld->value.closure, true);   // copy chld's struct (COW bindings)
env->parent   = par->value.closure->parent;        // take par's parent chain
env->bindings = par->value.closure->bindings;      // take par's bindings (replaces COW copy)
adopted->value.closure = env;
vm_push(vm, adopted);
```

The COW clone of `chld`'s bindings is immediately discarded and replaced by `par`'s bindings. The net effect is: the adopted closure has chld's code but par's scope.

When the adopted closure is called (via `ret` or `call_in`), `clone_env` with `cow=false` makes `vm->env->bindings` point directly to `par`'s bindings hashtable. Any `bind` executed inside the adopted closure writes into `par`'s bindings — **permanently modifying par's scope from within chld's code**.

## The `adopt` Use Case: Injecting Bindings into a Closure

The only current use of `adopt` is in `src/lib/dynamic.scm`, in the `bind-in` function that wires up FFI library functions into a caller closure:

```scheme
(define (bind-in alist closure)
    (if (null? alist)
      '()
      (begin
        (asm
          proc bind-in-done
          (alist) car           ; get one (key . value) pair
          proc do-bind
          (closure) adopt       ; run do-bind in closure's scope
          ret                   ; jump to do-bind

          do-bind:
            dup cdr swap car bind  ; bind value under key, in closure's env
            ret

          bind-in-done: ())
        (bind-in (cdr alist) closure))))
```

Tracing the stack and control flow:

1. `proc bind-in-done` — push a return closure pointing to `bind-in-done:`
2. `(alist) car` — push the first `(key . value)` pair from alist
3. `proc do-bind` — push a closure pointing to `do-bind:`, capturing the current scope (which has `alist` and `closure`)
4. `(closure) adopt` — pop `par=closure` and `chld=do-bind-closure`, produce an adopted closure whose code is `do-bind:` but whose `bindings` is `closure`'s bindings hashtable
5. `ret` — jump into the adopted closure (popping the current env, replacing with the adopted env)
6. Inside `do-bind:`, `bind` writes into `closure`'s bindings directly
7. `ret` — pops `bind-in-done` closure and returns

After this, `closure` has a new binding in its environment — the FFI function name mapped to the call wrapper. The `caller` returned by `import-bind` is the `closure`, so when it's later called, the FFI function is in scope.

`adopt` is essentially **scope surgery**: detaching a piece of code from its lexical context and reattaching it to execute in a different closure's scope, with the side effect that `bind` in that code mutates the target scope.

## Copy-on-Write Bindings

The hash table used for `env->bindings` supports copy-on-write via `hash_cow`. A COW table is created by `memcpy`-ing the header struct and setting a `copy_on_write` flag. The bucket array is initially shared with the original. On the first write (`CREATE` or `DELETE`), `hash_resize` materializes a private copy of all buckets, and the flag is cleared.

`clone_env(..., cow=true)` is used by `adopt`. In practice, the COW-copied bindings from `chld` are immediately replaced by `par`'s bindings pointer, so the COW table is discarded. The `cow=true` path in `clone_env` is intended for scenarios where you want a writable snapshot of an env's bindings without modifying the original — this would matter if `adopt` were later extended to not fully overwrite the bindings.
