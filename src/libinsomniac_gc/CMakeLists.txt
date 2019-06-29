
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(insomniac_gc
  gc_core.c
  gc_internals.c
  gc_sweep.c
  gc_types.c
  gc_util.c
  )

