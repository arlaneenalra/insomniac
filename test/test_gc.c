#include <stdio.h>
#include <string.h>

#include <insomniac.h>
#include <test.h>

/* Pull in the internal GC struct so tests can inspect counters directly
   without exposing them through the public API. */
#include "gc_internal.h"

/* Convenience macro: cast the opaque gc_type* to the internal struct. */
#define GC_INTERNAL(gc_ptr) ((gc_ms_type *)(gc_ptr))

/* cons is declared in vm_internal.h; redeclare here to avoid
   pulling in the full internal header. */
extern void cons(vm_type *vm, object_type *car, object_type *cdr,
                 object_type **pair_out);

/*
 * GC Validation Tests
 *
 * These tests build well-defined object graphs, force one or more GC
 * cycles, and then walk the graph to verify that every pointer was
 * correctly updated by the copying collector.
 */

gc_type *gc;
vm_type *vm;

/* ------------------------------------------------------------------ */
/*  Helpers                                                            */
/* ------------------------------------------------------------------ */

/* Burn through pool memory so that the next small allocation triggers
   a GC sweep.  Each iteration allocates a throwaway fixnum.  The
   objects become garbage immediately (not rooted). */
static void exhaust_pool(void) {
    for (int i = 0; i < 300000; i++) {
        vm_alloc(vm, FIXNUM);
    }
}

/* ------------------------------------------------------------------ */
/*  Setup / Teardown                                                   */
/* ------------------------------------------------------------------ */

/* Small pool so exhaust_pool() actually fills it (~18 K objects of 56 bytes
 * each before a sweep fires).  The default (40% of RAM, capped at 1 GB)
 * would never be exhausted by the 300 K iterations in exhaust_pool(). */
#define GC_TEST_POOL_SIZE (1 * 1024 * 1024) /* 1 MB */

void setup_hook(void) {
    gc = gc_create(sizeof(object_type), GC_TEST_POOL_SIZE);
    gc_set_validate(gc, true);

    gc_register_root(gc, (void **)&vm);
    vm_create(gc, 0, NULL, &vm);
}

void tear_down_hook(void) {
    vm_destroy(vm);
    gc_unregister_root(gc, (void **)&vm);
    gc_destroy(gc);
}

/* ------------------------------------------------------------------ */
/*  Test 1: A single pair survives GC                                  */
/* ------------------------------------------------------------------ */
int test_pair_survives_gc(void) {
    object_type *pair = 0;
    object_type *a = 0;
    object_type *b = 0;

    gc_register_root(gc, (void **)&pair);
    gc_register_root(gc, (void **)&a);
    gc_register_root(gc, (void **)&b);

    a = vm_alloc(vm, FIXNUM);
    a->value.integer = 42;

    b = vm_alloc(vm, FIXNUM);
    b->value.integer = 99;

    cons(vm, a, b, &pair);

    /* Force GC */
    gc_sweep(gc);

    /* Validate */
    if (pair->type != PAIR) { return 1; }
    if (pair->value.pair.car->type != FIXNUM) { return 1; }
    if (pair->value.pair.car->value.integer != 42) { return 1; }
    if (pair->value.pair.cdr->type != FIXNUM) { return 1; }
    if (pair->value.pair.cdr->value.integer != 99) { return 1; }

    gc_unregister_root(gc, (void **)&b);
    gc_unregister_root(gc, (void **)&a);
    gc_unregister_root(gc, (void **)&pair);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 2: A linked list survives GC                                  */
/* ------------------------------------------------------------------ */
int test_list_survives_gc(void) {
    object_type *list = 0;
    object_type *elem = 0;

    gc_register_root(gc, (void **)&list);
    gc_register_root(gc, (void **)&elem);

    /* Build (0 1 2 ... 99) as a proper list */
    list = vm_alloc(vm, EMPTY);
    for (int i = 99; i >= 0; i--) {
        elem = vm_alloc(vm, FIXNUM);
        elem->value.integer = i;
        cons(vm, elem, list, &list);
    }

    gc_sweep(gc);

    /* Walk the list and verify */
    object_type *cursor = list;
    for (int i = 0; i < 100; i++) {
        if (cursor->type != PAIR) {
            printf("list broken at element %d: expected PAIR, got %d\n",
                   i, cursor->type);
            return 1;
        }
        if (cursor->value.pair.car->value.integer != i) {
            printf("list[%d] = %" PRIi64 ", expected %d\n",
                   i, cursor->value.pair.car->value.integer, i);
            return 1;
        }
        cursor = cursor->value.pair.cdr;
    }
    if (cursor->type != EMPTY) { return 1; }

    gc_unregister_root(gc, (void **)&elem);
    gc_unregister_root(gc, (void **)&list);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 3: Strings survive GC                                         */
/* ------------------------------------------------------------------ */
int test_string_survives_gc(void) {
    object_type *str = 0;

    gc_register_root(gc, (void **)&str);

    str = vm_make_string(vm, "hello world", 11);

    gc_sweep(gc);

    if (str->type != STRING) { return 1; }
    if (str->value.string.length != 11) { return 1; }
    if (strcmp(str->value.string.bytes, "hello world") != 0) { return 1; }

    gc_unregister_root(gc, (void **)&str);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 4: A vector of pairs survives GC                              */
/* ------------------------------------------------------------------ */
int test_vector_of_pairs_survives_gc(void) {
    object_type *vec = 0;
    object_type *pair = 0;
    object_type *a = 0;
    object_type *b = 0;

    gc_register_root(gc, (void **)&vec);
    gc_register_root(gc, (void **)&pair);
    gc_register_root(gc, (void **)&a);
    gc_register_root(gc, (void **)&b);

    vec = vm_make_vector(vm, 50);

    for (int i = 0; i < 50; i++) {
        a = vm_alloc(vm, FIXNUM);
        a->value.integer = i;
        b = vm_alloc(vm, FIXNUM);
        b->value.integer = i * 10;
        cons(vm, a, b, &pair);
        vec->value.vector.vector[i] = pair;
    }

    gc_sweep(gc);

    /* Validate each pair */
    for (int i = 0; i < 50; i++) {
        object_type *p = vec->value.vector.vector[i];
        if (!p || p->type != PAIR) { return 1; }
        if (p->value.pair.car->value.integer != i) { return 1; }
        if (p->value.pair.cdr->value.integer != i * 10) { return 1; }
    }

    gc_unregister_root(gc, (void **)&b);
    gc_unregister_root(gc, (void **)&a);
    gc_unregister_root(gc, (void **)&pair);
    gc_unregister_root(gc, (void **)&vec);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 5: Object graph survives TWO GC cycles                        */
/* ------------------------------------------------------------------ */
int test_two_gc_cycles(void) {
    object_type *list = 0;
    object_type *elem = 0;

    gc_register_root(gc, (void **)&list);
    gc_register_root(gc, (void **)&elem);

    list = vm_alloc(vm, EMPTY);
    for (int i = 49; i >= 0; i--) {
        elem = vm_alloc(vm, FIXNUM);
        elem->value.integer = i;
        cons(vm, elem, list, &list);
    }

    /* First GC */
    gc_sweep(gc);

    /* Second GC -- old_pool from first sweep is freed here */
    gc_sweep(gc);

    /* Verify the list */
    object_type *cursor = list;
    for (int i = 0; i < 50; i++) {
        if (cursor->type != PAIR) { return 1; }
        if (cursor->value.pair.car->value.integer != i) { return 1; }
        cursor = cursor->value.pair.cdr;
    }
    if (cursor->type != EMPTY) { return 1; }

    gc_unregister_root(gc, (void **)&elem);
    gc_unregister_root(gc, (void **)&list);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 6: Graph built across a GC boundary                           */
/*  Build half the list, trigger GC, build the rest, trigger GC again  */
/* ------------------------------------------------------------------ */
int test_graph_across_gc_boundary(void) {
    object_type *list = 0;
    object_type *elem = 0;

    gc_register_root(gc, (void **)&list);
    gc_register_root(gc, (void **)&elem);

    /* Build second half first (50..99) */
    list = vm_alloc(vm, EMPTY);
    for (int i = 99; i >= 50; i--) {
        elem = vm_alloc(vm, FIXNUM);
        elem->value.integer = i;
        cons(vm, elem, list, &list);
    }

    /* GC in the middle */
    gc_sweep(gc);

    /* Build first half (0..49) onto the surviving list */
    for (int i = 49; i >= 0; i--) {
        elem = vm_alloc(vm, FIXNUM);
        elem->value.integer = i;
        cons(vm, elem, list, &list);
    }

    /* Final GC */
    gc_sweep(gc);

    /* Verify 0..99 */
    object_type *cursor = list;
    for (int i = 0; i < 100; i++) {
        if (cursor->type != PAIR) { return 1; }
        if (cursor->value.pair.car->value.integer != i) { return 1; }
        cursor = cursor->value.pair.cdr;
    }
    if (cursor->type != EMPTY) { return 1; }

    gc_unregister_root(gc, (void **)&elem);
    gc_unregister_root(gc, (void **)&list);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 7: GC triggered by memory pressure (not explicit sweep)       */
/* ------------------------------------------------------------------ */
int test_gc_under_pressure(void) {
    gc_ms_type *igc = GC_INTERNAL(gc);
    object_type *list = 0;
    object_type *elem = 0;
    int result = 0;

    /* Per-object cost for every allocation in this test.
     *
     * This test is intentionally brittle about exact byte counts: all
     * objects allocated here (FIXNUM and PAIR) are sizeof(object_type)
     * each, so they share a single real_size in internal_alloc.  That lets
     * us assert exact deltas rather than just thresholds.  If object_type
     * or meta_obj_type ever changes size these assertions will fail and
     * the constant below should be updated.  The brittleness is acceptable
     * because catching unexpected size changes is part of the point.
     *
     * Note: vm_alloc(vm, EMPTY) returns vm->empty, a pre-allocated
     * singleton -- it does NOT increment allocations. */
    const vm_int obj_size =
        (vm_int)(sizeof(meta_obj_type) + sizeof(object_type));

    /* Register roots before the baseline sweep so any sweep that fires
     * during list building updates these pointers correctly.  We use
     * goto cleanup throughout to ensure they are always unregistered --
     * leaving dangling stack roots in the list corrupts subsequent sweeps. */
    gc_register_root(gc, (void **)&list);
    gc_register_root(gc, (void **)&elem);

    /* Establish a clean baseline so free is known relative to a sweep. */
    gc_sweep(gc);
    vm_int base_allocs = igc->allocations;
    vm_int base_free   = igc->free;

    /* Build (0 1 2 ... 99): 100 FIXNUM + 100 PAIR = 200 new objects.
     * (EMPTY is a singleton; vm_alloc returns vm->empty without allocating.) */
    list = vm_alloc(vm, EMPTY);
    for (int i = 99; i >= 0; i--) {
        elem = vm_alloc(vm, FIXNUM);
        elem->value.integer = i;
        cons(vm, elem, list, &list);
    }

    /* Verify exact allocation deltas before applying memory pressure. */
    if (igc->allocations != base_allocs + 200) {
        printf("after list build: expected allocations=%" PRIi64
               ", got %" PRIi64 "\n",
               base_allocs + 200, igc->allocations);
        result = 1;
        goto cleanup;
    }
    if (igc->free != base_free - 200 * obj_size) {
        printf("after list build: expected free=%" PRIi64
               ", got %" PRIi64 "\n",
               base_free - 200 * obj_size, igc->free);
        result = 1;
        goto cleanup;
    }

    /* exhaust_pool triggers multiple implicit GC sweeps.  After each sweep
     * the live set is (base + 200 list objects), so free resets to
     * base_free - 200 * obj_size before the next fill begins.
     * After the loop some iterations will have run since the last sweep,
     * leaving free in an indeterminate state -- hence the explicit sweep
     * below to normalise before measuring. */
    exhaust_pool();

    /* Normalise: sweep out the garbage left by exhaust_pool so subsequent
     * counter checks are against a clean state. */
    gc_sweep(gc);

    if (igc->allocations != base_allocs + 200) {
        printf("after pressure sweep: expected allocations=%" PRIi64
               ", got %" PRIi64 "\n",
               base_allocs + 200, igc->allocations);
        result = 1;
        goto cleanup;
    }
    if (igc->free != base_free - 200 * obj_size) {
        printf("after pressure sweep: expected free=%" PRIi64
               ", got %" PRIi64 "\n",
               base_free - 200 * obj_size, igc->free);
        result = 1;
        goto cleanup;
    }

    /* Allocate one more object (the -1 sentinel); verify the counters
     * reflect exactly one additional allocation. */
    elem = vm_alloc(vm, FIXNUM);
    elem->value.integer = -1;

    if (igc->allocations != base_allocs + 201) {
        printf("after final alloc: expected allocations=%" PRIi64
               ", got %" PRIi64 "\n",
               base_allocs + 201, igc->allocations);
        result = 1;
        goto cleanup;
    }
    if (igc->free != base_free - 201 * obj_size) {
        printf("after final alloc: expected free=%" PRIi64
               ", got %" PRIi64 "\n",
               base_free - 201 * obj_size, igc->free);
        result = 1;
        goto cleanup;
    }

    /* Verify the list is still intact after all the GC activity. */
    {
        object_type *cursor = list;
        for (int i = 0; i < 100; i++) {
            if (cursor->type != PAIR) { result = 1; goto cleanup; }
            if (cursor->value.pair.car->value.integer != i) {
                result = 1;
                goto cleanup;
            }
            cursor = cursor->value.pair.cdr;
        }
        if (cursor->type != EMPTY) { result = 1; goto cleanup; }
    }

cleanup:
    gc_unregister_root(gc, (void **)&elem);
    gc_unregister_root(gc, (void **)&list);
    return result;
}

/* ------------------------------------------------------------------ */
/*  Test 8: Nested vectors survive GC                                  */
/* ------------------------------------------------------------------ */
int test_nested_vectors_survive_gc(void) {
    object_type *outer = 0;
    object_type *inner = 0;
    object_type *val = 0;

    gc_register_root(gc, (void **)&outer);
    gc_register_root(gc, (void **)&inner);
    gc_register_root(gc, (void **)&val);

    outer = vm_make_vector(vm, 10);

    for (int i = 0; i < 10; i++) {
        inner = vm_make_vector(vm, 5);
        for (int j = 0; j < 5; j++) {
            val = vm_alloc(vm, FIXNUM);
            val->value.integer = i * 100 + j;
            inner->value.vector.vector[j] = val;
        }
        outer->value.vector.vector[i] = inner;
    }

    gc_sweep(gc);
    gc_sweep(gc);

    /* Validate the 10x5 matrix */
    for (int i = 0; i < 10; i++) {
        object_type *row = outer->value.vector.vector[i];
        if (!row || row->type != VECTOR) { return 1; }
        if (row->value.vector.length != 5) { return 1; }
        for (int j = 0; j < 5; j++) {
            object_type *v = row->value.vector.vector[j];
            if (!v || v->type != FIXNUM) { return 1; }
            if (v->value.integer != i * 100 + j) { return 1; }
        }
    }

    gc_unregister_root(gc, (void **)&val);
    gc_unregister_root(gc, (void **)&inner);
    gc_unregister_root(gc, (void **)&outer);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 9: Mixed-type graph survives GC                               */
/*  A list of (string . fixnum) pairs                                  */
/* ------------------------------------------------------------------ */
int test_mixed_type_graph(void) {
    object_type *list = 0;
    object_type *pair = 0;
    object_type *str = 0;
    object_type *num = 0;

    gc_register_root(gc, (void **)&list);
    gc_register_root(gc, (void **)&pair);
    gc_register_root(gc, (void **)&str);
    gc_register_root(gc, (void **)&num);

    list = vm_alloc(vm, EMPTY);
    char buf[32];
    for (int i = 19; i >= 0; i--) {
        snprintf(buf, sizeof(buf), "item-%d", i);
        str = vm_make_string(vm, buf, strlen(buf));
        num = vm_alloc(vm, FIXNUM);
        num->value.integer = i;
        cons(vm, str, num, &pair);
        cons(vm, pair, list, &list);
    }

    gc_sweep(gc);
    gc_sweep(gc);

    /* Verify */
    object_type *cursor = list;
    for (int i = 0; i < 20; i++) {
        if (cursor->type != PAIR) { return 1; }
        object_type *p = cursor->value.pair.car;
        if (p->type != PAIR) { return 1; }

        /* Check string */
        snprintf(buf, sizeof(buf), "item-%d", i);
        if (p->value.pair.car->type != STRING) { return 1; }
        if (strcmp(p->value.pair.car->value.string.bytes, buf) != 0) {
            printf("Expected '%s', got '%s'\n", buf,
                   p->value.pair.car->value.string.bytes);
            return 1;
        }

        /* Check fixnum */
        if (p->value.pair.cdr->value.integer != i) { return 1; }

        cursor = cursor->value.pair.cdr;
    }
    if (cursor->type != EMPTY) { return 1; }

    gc_unregister_root(gc, (void **)&num);
    gc_unregister_root(gc, (void **)&str);
    gc_unregister_root(gc, (void **)&pair);
    gc_unregister_root(gc, (void **)&list);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 10: sweeps counter increments with each collection cycle      */
/* ------------------------------------------------------------------ */
int test_sweeps_counter(void) {
    gc_ms_type *igc = GC_INTERNAL(gc);
    vm_int initial = igc->sweeps;

    gc_sweep(gc);
    if (igc->sweeps != initial + 1) {
        printf("after sweep 1: expected sweeps=%" PRIi64 ", got %" PRIi64 "\n",
               initial + 1, igc->sweeps);
        return 1;
    }

    gc_sweep(gc);
    if (igc->sweeps != initial + 2) {
        printf("after sweep 2: expected sweeps=%" PRIi64 ", got %" PRIi64 "\n",
               initial + 2, igc->sweeps);
        return 1;
    }

    gc_sweep(gc);
    if (igc->sweeps != initial + 3) {
        printf("after sweep 3: expected sweeps=%" PRIi64 ", got %" PRIi64 "\n",
               initial + 3, igc->sweeps);
        return 1;
    }

    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 11: dead objects are collected; allocations and free recover  */
/* ------------------------------------------------------------------ */
int test_dead_objects_collected(void) {
    gc_ms_type *igc = GC_INTERNAL(gc);

    /* Establish a clean baseline after a sweep. */
    gc_sweep(gc);
    vm_int base_allocs = igc->allocations;
    vm_int base_free   = igc->free;
    vm_int base_sweeps = igc->sweeps;

    /* Allocate 20 objects WITHOUT rooting them -- pure garbage. */
    const int N = 20;
    for (int i = 0; i < N; i++) {
        object_type *tmp = vm_alloc(vm, FIXNUM);
        tmp->value.integer = i;
    }

    /* Counters should reflect the new allocations. */
    if (igc->allocations != base_allocs + N) {
        printf("before sweep: expected allocations=%" PRIi64 ", got %" PRIi64 "\n",
               base_allocs + N, igc->allocations);
        return 1;
    }
    if (igc->free >= base_free) {
        printf("before sweep: free should have decreased (was %" PRIi64 ", now %" PRIi64 ")\n",
               base_free, igc->free);
        return 1;
    }

    /* After a sweep, only the baseline live set should remain. */
    gc_sweep(gc);

    if (igc->sweeps != base_sweeps + 1) {
        printf("sweeps should be %" PRIi64 ", got %" PRIi64 "\n",
               base_sweeps + 1, igc->sweeps);
        return 1;
    }
    if (igc->allocations != base_allocs) {
        printf("after sweep: expected allocations=%" PRIi64 " (garbage collected), got %" PRIi64 "\n",
               base_allocs, igc->allocations);
        return 1;
    }
    if (igc->free != base_free) {
        printf("after sweep: expected free=%" PRIi64 " (space recovered), got %" PRIi64 "\n",
               base_free, igc->free);
        return 1;
    }

    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test 12: multi-cycle: root a set, collect garbage each cycle,      */
/*           verify counters stay consistent across sweeps             */
/* ------------------------------------------------------------------ */
int test_multi_cycle_collection(void) {
    gc_ms_type *igc = GC_INTERNAL(gc);
    object_type *a = 0;
    object_type *b = 0;
    object_type *c = 0;

    gc_register_root(gc, (void **)&a);
    gc_register_root(gc, (void **)&b);
    gc_register_root(gc, (void **)&c);

    /* Baseline after a clean sweep. */
    gc_sweep(gc);
    vm_int base_allocs = igc->allocations;
    vm_int base_free   = igc->free;
    vm_int base_sweeps = igc->sweeps;

    /* --- Cycle 1: root a and b, let 10 objects die --- */
    a = vm_alloc(vm, FIXNUM);
    a->value.integer = 1;
    b = vm_alloc(vm, FIXNUM);
    b->value.integer = 2;
    for (int i = 0; i < 10; i++) {
        vm_alloc(vm, FIXNUM); /* garbage */
    }

    gc_sweep(gc);

    /* a and b survive; 10 unrooted are gone. */
    if (igc->sweeps != base_sweeps + 1) { return 1; }
    if (igc->allocations != base_allocs + 2) {
        printf("cycle 1: expected allocations=%" PRIi64 ", got %" PRIi64 "\n",
               base_allocs + 2, igc->allocations);
        return 1;
    }

    vm_int after_cycle1_free = igc->free;
    if (after_cycle1_free >= base_free) {
        printf("cycle 1: free should be less than baseline (base=%" PRIi64 ", now=%" PRIi64 ")\n",
               base_free, after_cycle1_free);
        return 1;
    }

    /* --- Cycle 2: add c, let 15 objects die --- */
    c = vm_alloc(vm, FIXNUM);
    c->value.integer = 3;
    for (int i = 0; i < 15; i++) {
        vm_alloc(vm, FIXNUM); /* garbage */
    }

    gc_sweep(gc);

    if (igc->sweeps != base_sweeps + 2) { return 1; }
    if (igc->allocations != base_allocs + 3) {
        printf("cycle 2: expected allocations=%" PRIi64 ", got %" PRIi64 "\n",
               base_allocs + 3, igc->allocations);
        return 1;
    }

    /* free should be less than after cycle 1 (we now carry a, b, c). */
    if (igc->free >= after_cycle1_free) {
        printf("cycle 2: free should be less than after cycle 1\n");
        return 1;
    }

    /* --- Cycle 3: drop c (let it die), keep a and b --- */
    c = 0;
    for (int i = 0; i < 5; i++) {
        vm_alloc(vm, FIXNUM); /* more garbage */
    }

    gc_sweep(gc);

    if (igc->sweeps != base_sweeps + 3) { return 1; }
    /* c is now garbage; should be back to base + 2. */
    if (igc->allocations != base_allocs + 2) {
        printf("cycle 3: expected allocations=%" PRIi64 " after dropping c, got %" PRIi64 "\n",
               base_allocs + 2, igc->allocations);
        return 1;
    }
    /* free should recover to what it was after cycle 1 (same live set: a, b). */
    if (igc->free != after_cycle1_free) {
        printf("cycle 3: expected free=%" PRIi64 " (c reclaimed), got %" PRIi64 "\n",
               after_cycle1_free, igc->free);
        return 1;
    }

    /* Verify a and b still hold their values. */
    if (a->value.integer != 1 || b->value.integer != 2) { return 1; }

    gc_unregister_root(gc, (void **)&c);
    gc_unregister_root(gc, (void **)&b);
    gc_unregister_root(gc, (void **)&a);
    return 0;
}

/* ------------------------------------------------------------------ */
/*  Test case table                                                    */
/* ------------------------------------------------------------------ */
test_case_type cases[] = {
    {&test_pair_survives_gc,           "Pair survives GC"},
    {&test_list_survives_gc,           "Linked list survives GC"},
    {&test_string_survives_gc,         "String survives GC"},
    {&test_vector_of_pairs_survives_gc,"Vector of pairs survives GC"},
    {&test_two_gc_cycles,              "Object graph survives two GC cycles"},
    {&test_graph_across_gc_boundary,   "Graph built across GC boundary"},
    {&test_gc_under_pressure,          "GC triggered by memory pressure"},
    {&test_nested_vectors_survive_gc,  "Nested vectors survive GC"},
    {&test_mixed_type_graph,           "Mixed-type graph survives GC"},
    {&test_sweeps_counter,             "Sweeps counter increments correctly"},
    {&test_dead_objects_collected,     "Dead objects collected; allocations and free recover"},
    {&test_multi_cycle_collection,     "Multi-cycle: counters consistent across sweeps"},
    {0, 0}
};
