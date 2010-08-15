#ifndef _UTIL_
#define _UTIL

/* Add in some debugging messages */
#ifdef DEBUG
#define TRACE(x)  (void)fprintf(stderr, "%s",x);
#else
#define TRACE(x)
#endif



#endif
