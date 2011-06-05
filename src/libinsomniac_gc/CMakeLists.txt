
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(libinsomniac_gc 
  gc_core.c
  internals.c
  sweep.c
  offset.c
  types.c
  )

