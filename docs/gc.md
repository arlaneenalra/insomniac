# Garbage Collector

The GC lives in `src/libinsomniac_gc/`. It is a **Cheney-style semi-space copying collector**: it maintains a single memory pool and, on each sweep, copies all live objects to a freshly allocated pool, leaving the old pool to be freed.

## Memory Layout

All GC-managed objects share a common layout:

```
+------------------+
|  meta_obj_type   |  header (GC metadata)
+------------------+
|   user data[]    |  the actual object (flexible array member)
+------------------+
```

The `meta_obj_type` header:

```c
typedef struct meta_obj {
    int    mark;      // LIVE, FORWARDING, or FIXED
    size_t size;      // size of user data in bytes; repurposed as forwarding pointer during sweep
    int    type_def;  // index into type_def array, or -1 for untyped blobs
    char   obj[];     // user data starts here
} meta_obj_type;
```

**Mark values:**
- `LIVE` — normal live object
- `FORWARDING` — this object has been copied; `meta->size` now holds the address of the copy in to-space (the forwarding pointer)
- `FIXED` — pinned object; never moved or freed (used for bytecode embedded in native executables)

## Allocation

`gc_alloc_type(gc, size, type_def)` — bump-allocates from `gc->memory_pool_head`:

```c
void *gc_alloc_type(gc_type *gc, size_t size, int type_def) {
    size_t alloc_size = sizeof(meta_obj_type) + MAX(size, sizeof(void*));
    gc->memory_pool_head -= alloc_size;
    if (gc->memory_pool_head < 0) {
        gc_sweep(gc);
        gc->memory_pool_head -= alloc_size;
    }
    meta_obj_type *meta = pool_ptr(gc, gc->memory_pool_head);
    meta->mark     = LIVE;
    meta->size     = size;
    meta->type_def = type_def;
    return meta->obj;
}
```

The minimum allocation is `sizeof(void*)` bytes of user data to ensure there is always room to write a forwarding pointer during copying.

## Type Registration

The GC needs to know which bytes inside an object are pointers so it can trace the object graph. Types register their layout:

```c
int gc_register_type(gc_type *gc, size_t size);
void gc_register_pointer(gc_type *gc, int type_def, size_t offset);
void gc_register_array(gc_type *gc, int type_def, size_t offset, size_t element_size);
```

`gc_register_type` returns a `type_def` integer (an index). Then you call `gc_register_pointer` for each pointer field at a given byte offset, or `gc_register_array` for a pointer array (e.g., a vector's `object_type**` data pointer).

**PTR** — a single pointer at `offset`. During sweep, `copy_graph` follows this pointer.
**ARRAY** — a pointer array at `offset`. The number of elements is computed from `meta->size / element_size`. Each element is followed.

All VM cell types are registered in `vm_types.c`. Examples:
- PAIR: two PTR entries (offsets of `car` and `cdr`)
- STRING: one PTR (offset of `bytes` char array)
- VECTOR: one ARRAY (offset of `vector` pointer array, element size = `sizeof(object_type*)`)
- CLOSURE: one PTR (offset of the `env_type*`)

Untyped allocations (`type_def = -1`) are treated as opaque blobs with no interior pointers — used for raw byte arrays (bytecode, string data buffers, etc.).

## Root Registration

GC roots are registered/unregistered dynamically:

```c
void gc_register_root(gc_type *gc, void **root);
void gc_unregister_root(gc_type *gc, void **root);
```

Roots are stored as a linked list of `meta_root_type` entries, each holding a `void**` (pointer to the root pointer). During sweep, each registered root is updated to point to the copy of the object it referred to.

Unregistered roots go onto a `pruned_root_list` freelist for reuse, avoiding malloc/free churn.

The VM registers roots for:
- `vm->stack_root`
- `vm->env` (current environment)
- `vm->reg1`, `vm->reg2`, `vm->reg3` (per-instruction temporaries)
- The symbol table's internal storage

## The Sweep (`gc_sweep.c`)

```c
void gc_sweep(gc_type *gc) {
    if (gc->protect_count > 0) return;   // GC is protected, skip

    free(gc->old_pool);                  // free the pool from the previous sweep
    gc->old_pool = gc->memory_pool;      // save current pool (deferred free)

    // allocate fresh to-space
    gc->memory_pool = malloc(gc->pool_size);
    gc->memory_pool_head = gc->pool_size;

    // copy all live objects reachable from roots
    for each root in gc->root_list:
        *root = copy_graph(gc, *root);
}
```

The old pool is **not freed immediately** — it is kept one cycle as `gc->old_pool`. This provides a window where stale pointers into the old pool remain valid for diagnostic purposes, and gives instruction handlers a brief grace period (though correct code should have no stale pointers).

## `copy_graph` — The Core Algorithm

```c
void *copy_graph(gc_type *gc, void *ptr) {
    if (ptr == NULL) return NULL;
    meta_obj_type *meta = meta_of(ptr);

    if (meta->mark == FIXED)      return ptr;          // pinned, don't move
    if (meta->mark == FORWARDING) return (void*)meta->size;  // already copied

    // allocate in to-space
    void *new_ptr = gc_alloc_in_tospace(gc, meta->size, meta->type_def);
    memcpy(new_ptr, ptr, meta->size);

    // mark old object as forwarding
    meta->mark = FORWARDING;
    meta->size = (size_t)new_ptr;   // forwarding pointer stored in size field

    // recursively copy all pointer fields
    meta_obj_type *new_meta = meta_of(new_ptr);
    for each pointer field p in new_meta (per type_def):
        *p = copy_graph(gc, *p);

    return new_ptr;
}
```

This is a standard recursive Cheney walk. Because it recurses depth-first, deeply nested structures may cause C stack overflow on very large heaps; a production implementation would use a work queue.

## GC Protection

```c
void gc_protect(gc_type *gc);
void gc_unprotect(gc_type *gc);
```

These increment/decrement `gc->protect_count`. While `protect_count > 0`, `gc_sweep` is a no-op. Used by the bootstrap compiler during parsing to avoid sweeping C data structures that are not registered as GC roots.

## Validation Mode

```c
void gc_set_validate(gc_type *gc, bool validate);
```

When enabled, `copy_graph` asserts that every pointer it follows points into the current from-space pool, and that every forwarding pointer points into the to-space. Violations are reported with diagnostic output and abort. This is a debugging aid used in test builds.

## Pool Sizing

The initial pool size is set at VM creation. When `gc_alloc_type` would overflow the pool after a sweep (i.e., the program's live set exceeds pool capacity), the current implementation will fail. There is no dynamic pool resizing. Pool size must be chosen large enough for the expected working set.

## What the GC Does Not Do

- **No compaction** beyond what copying provides (copying is inherently compacting).
- **No generational collection** — all live objects are always traced on every sweep.
- **No concurrent or incremental collection** — the sweep is a stop-the-world pause.
- **No finalizers** — there is no mechanism to run code when an object is collected.
- **No weak references**.
- **No interior pointers** — all GC-managed pointers must point to the start of an allocation header.
