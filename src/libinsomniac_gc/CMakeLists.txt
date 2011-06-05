
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(libinsomniac_gc 
  gc_core.c
  gc_internals.c
  gc_sweep.c
  gc_offset.c
  gc_types.c
  )

