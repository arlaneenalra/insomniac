
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

find_package(FLEX)

# flex generates a .h file, it would appear that no one handles this correctly
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES ${CMAKE_CURRENT_BINARY_DIR}/lexer.h)

FLEX_TARGET(LEXER lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c
  COMPILE_FLAGS "--header-file=${CMAKE_CURRENT_BINARY_DIR}/lexer.h")

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})


add_library(libinsomniac_asm
  asm_core.c
  ${FLEX_LEXER_OUTPUTS}
  )
