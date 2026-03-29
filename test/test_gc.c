#include <stdio.h>
#include <string.h>

#include <insomniac.h>
#include <test.h>

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

void setup_hook(void) {
    gc = gc_create(sizeof(object_type));
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
    object_type *list = 0;
    object_type *elem = 0;

    gc_register_root(gc, (void **)&list);
    gc_register_root(gc, (void **)&elem);

    list = vm_alloc(vm, EMPTY);
    for (int i = 99; i >= 0; i--) {
        elem = vm_alloc(vm, FIXNUM);
        elem->value.integer = i;
        cons(vm, elem, list, &list);
    }

    /* Exhaust pool to trigger GC implicitly on next alloc */
    exhaust_pool();

    /* This allocation should trigger a sweep internally */
    elem = vm_alloc(vm, FIXNUM);
    elem->value.integer = -1;

    /* Verify the list is still intact */
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
    {0, 0}
};
