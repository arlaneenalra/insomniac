#ifndef _BOOTSTRAP_
#define _BOOTSTRAP_

#include <buffer.h>

typedef void compiler_type;

/* create a compiler instance */
void compiler_create(gc_type *gc, compiler_type **comp);

/* compile a string into an instruction stream */
void compile_string(compiler_type *comp, char *str, bool include_baselib);

/* compile a file into an instruction stream */
void compile_file(compiler_type *comp, char *file_name, bool include_baselib);

void compiler_code_gen(compiler_type *comp, buffer_type *buf, bool bootstrap);

#endif
