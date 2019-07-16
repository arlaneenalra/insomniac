
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(
    ${PROJECT_SOURCE_DIR}/core
    ${PROJECT_SOURCE_DIR}/core/lexer)

file(GLOB_RECURSE INSC_SCM_TARGETS FOLLOW_SYMLINKS
    ${CMAKE_SOURCE_DIR}/src/core/lexer/*.scm
    ${CMAKE_SOURCE_DIR}/src/core/scheme/*.scm)

INSC_TARGET(REPL_SCM "insomniac-core.scm" "insc" ${INSC_SCM_TARGETS})

file(GLOB_RECURSE INSC_ASM_SCM_TARGETS FOLLOW_SYMLINKS
    ${CMAKE_SOURCE_DIR}/src/core/lexer/*.scm
    ${CMAKE_SOURCE_DIR}/src/core/asm/*.scm)

INSC_TARGET(REPL_SCM "asm-core.scm" "insc-as" ${INSC_ASM_SCM_TARGETS})

