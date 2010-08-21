#ifndef _UTIL_
#define _UTIL

#include <stdio.h>

/* Add in some debugging messages */
#ifdef DEBUG
#define TRACE(x)  (void)fprintf(stderr, "%s",x);
#else
#define TRACE(x)
#endif

extern void fail(const char *msg);

#endif
