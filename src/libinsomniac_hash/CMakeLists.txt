
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(libinsomniac_hash
  hash_core.c
  hash_string_functions.c
  hash_types.c
  )
