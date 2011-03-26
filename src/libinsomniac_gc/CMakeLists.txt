include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(libinsomniac_gc 
  gc_core.c
  )

include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)