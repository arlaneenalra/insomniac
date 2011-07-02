#ifndef _TESTER_
#define _TESTER_

typedef struct test_case {
    int (*test)(); /* the test case to run */
    char *message;
} test_case_type;

extern test_case_type cases[]; /* define with a list of test cases */


#endif
