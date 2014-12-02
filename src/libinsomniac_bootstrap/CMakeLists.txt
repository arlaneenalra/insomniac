
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

# setup flex and bison
find_package(BISON)
find_package(FLEX)

# flex generates a .h file, it would appear that no one handles this correctly
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${CMAKE_CURRENT_BINARY_DIR}/lexer.h)

BISON_TARGET(PARSER scheme.y ${CMAKE_CURRENT_BINARY_DIR}/scheme.c
  VERBOSE "bison.log")
FLEX_TARGET(LEXER lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c
  COMPILE_FLAGS "--header-file=${CMAKE_CURRENT_BINARY_DIR}/lexer.h")

ADD_FLEX_BISON_DEPENDENCY(LEXER PARSER)

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

add_library(insomniac_bootstrap
  bootstrap_core.c
  bootstrap_preamble.c
  bootstrap_emit.c
  bootstrap_emit_formatting.c
  bootstrap_stream.c
  bootstrap_stream_nodes.c
  ${BISON_PARSER_OUTPUTS} 
  ${FLEX_LEXER_OUTPUTS})

