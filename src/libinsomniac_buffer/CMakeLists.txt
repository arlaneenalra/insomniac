
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(insomniac_buffer
  buffer_core.c
  buffer_load.c
  buffer_open.c
  )

