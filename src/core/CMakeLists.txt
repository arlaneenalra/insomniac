
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(
    ${PROJECT_SOURCE_DIR}/core
    ${PROJECT_SOURCE_DIR}/core/lexer)

file(GLOB_RECURSE INSC_SCM_TARGETS FOLLOW_SYMLINKS ${CMAKE_SOURCE_DIR}/src/core/lexer/*.scm)

INSC_TARGET(REPL_SCM "insomniac-core.scm" "insc" ${INSC_SCM_TARGETS})

