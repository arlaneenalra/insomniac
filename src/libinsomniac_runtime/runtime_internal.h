#ifndef _RUNTIME_INTERNAL_
#define _RUNTIME_INTERNAL_

#include <assert.h>
#include <stdio.h>

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <insomniac.h>

#include <locale.h>

/* Represents how debug data is written into the executable. */
typedef struct debug_range {
    char * file;

    uint64_t line;
    uint64_t column;
    uint64_t start_addr;

} debug_range_type;

#endif
