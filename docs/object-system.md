# Object System

All Scheme values in Insomniac are represented as heap-allocated `object_type` structs (defined in `src/include/cell.h`). There is no NaN-boxing or pointer tagging — every value is a separately heap-allocated tagged union.

## The Core Type

```c
typedef struct object {
    cell_type   type;   // discriminant enum
    value_type  value;  // union of all value payloads
} object_type;
```

All `object_type` instances are allocated via `vm_alloc(vm, cell_type)`, which calls `gc_alloc_type(vm->gc, sizeof(object_type), type_handle)`. The GC type handle tells the collector which fields inside `value` are pointers to other GC-managed objects.

## Cell Types

### FIXNUM
```c
vm_int integer;   // int64_t
```
64-bit signed integer. The only numeric type; there are no floats or bignums.

### BOOL
```c
bool boolean;
```
`#t` or `#f`. The VM maintains singleton objects for true and false; these are allocated once and their addresses are cached in `vm->true_obj` and `vm->false_obj`.

### CHAR
```c
vm_char character;   // uint32_t — Unicode codepoint
```
Full Unicode support via 32-bit codepoints. `int->char` and `char->int` convert between fixnums and characters.

### STRING
```c
struct {
    vm_int       length;  // byte count
    char        *bytes;   // GC-managed byte array (not null-terminated)
    hash_state_type state; // cached hash (lazy)
} string;
```
Strings are mutable. The `bytes` pointer is a separate GC allocation (type `-1`, untyped blob). The GC traces the `bytes` pointer as a PTR field.

### SYMBOL
Same memory layout as STRING. Symbols are interned via `vm->symbol_table` (a string-keyed hashtable). Two symbols with the same name are `eq?` because they are the same heap object. `op_sym` performs the interning: look up the string in the table; if found, return the existing symbol; otherwise allocate a new SYMBOL cell, store it in the table, and return it.

### PAIR
```c
struct {
    object_type *car;
    object_type *cdr;
} pair;
```
Mutable cons cells. Both `car` and `cdr` are GC-traced PTR fields. `set-car!` and `set-cdr!` mutate in place.

### EMPTY
Singleton empty list `()`. Allocated once, never collected. No meaningful value field. `null?` checks `type == EMPTY`.

### VECTOR
```c
struct {
    vm_int        length;   // element count
    object_type **vector;   // GC-managed array of pointers
} vector;
```
The `vector` pointer is a separate GC allocation registered as an ARRAY field (element size = `sizeof(object_type*)`). The GC traces each element pointer individually.

### BYTE_VECTOR
```c
struct {
    vm_int    length;   // byte count
    uint8_t  *vector;   // GC-managed raw byte array
} byte_vector;
```
The `vector` pointer is an untyped GC blob (no interior pointers). Used for binary data, UTF-8 string encoding, and bytecode storage.

### RECORD
Same memory layout as VECTOR (`length` + `object_type**`). Shares the same GC type registration as VECTOR. By convention, element 0 is the **record type identifier** (a symbol), and subsequent elements are the field values. This means records have no separate type-descriptor object — the type is encoded in `record[0]`.

### CLOSURE
```c
void *closure;   // actually env_type* — the captured environment
```
A closure is a GC-managed object whose payload is a pointer to an `env_type`. The GC traces the `closure` pointer as a PTR field. Closures are created by `OP_PROC` (which snapshots the current environment at the current IP) and called by `OP_CALL_IN` / `OP_TAIL_CALL_IN` / `OP_JIN`.

### LIBRARY
```c
struct {
    void    *handle;       // dlopen handle — NOT GC-traced
    void    *functions;    // pointer to export table — NOT GC-traced
    vm_int   func_count;
} library;
```
Represents a dynamically loaded shared library. The `handle` and `functions` pointers are C resources outside the GC heap; the GC has no type registration for them. Libraries are loaded with `OP_IMPORT` and called via `OP_CALL_EXT`.

## Allocation

All objects go through:
```c
object_type *vm_alloc(vm_internal_type *vm, cell_type type);
```
which selects the appropriate GC type handle (registered in `vm_types.c`) and calls `gc_alloc_type`. Most cell types require one allocation for the `object_type` struct, but STRING, SYMBOL, VECTOR, BYTE_VECTOR, and RECORD require a **second allocation** for their data buffer.

## Singletons

The following objects are allocated once at VM startup and reused:
- `vm->true_obj` (`#t`)
- `vm->false_obj` (`#f`)
- `vm->empty_obj` (`()`)

These are GC roots and are never freed. Code can compare pointers to check for these values, but the type predicates (`bool?`, `null?`) check `cell_type` instead.

## Type Predicates

Each cell type has a corresponding predicate opcode:

| Opcode | Cell type checked |
|--------|------------------|
| `fixnum?` | FIXNUM |
| `bool?` | BOOL |
| `char?` | CHAR |
| `string?` | STRING |
| `symbol?` | SYMBOL |
| `pair?` | PAIR |
| `null?` | EMPTY |
| `vector?` | VECTOR |
| `vector-u8?` | BYTE_VECTOR |
| `record?` | RECORD |
| `proc?` | CLOSURE |

`self?` is special: it checks if the top of stack is the same object as the current closure (used in recursive self-reference optimizations).

## Equality

- `eq?` — pointer equality. Works correctly for symbols (interned), booleans (singletons), and `()` (singleton). Not meaningful for freshly-allocated strings, pairs, vectors, or closures.
- `=` — numeric equality (FIXNUM only).
- `equal?` — deep structural equality, implemented in Scheme in `src/lib/predicates.scm`.

## Missing Types

- **Flonum** — there is no floating-point cell type. The lexer in `core/scheme/lexer.scm` tokenizes float literals but the VM has no representation for them.
- **Port** — I/O ports are represented as records at the Scheme level, wrapping C file handles via the FFI.
- **Bignum** — no arbitrary-precision integers.
- **Exact/Inexact** — no numeric tower; all numbers are fixnums.
