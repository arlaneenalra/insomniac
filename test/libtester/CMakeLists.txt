
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)
include(${PROJECT_SOURCE_DIR}/CMakeTestIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(tester
  tester_main.c
  )
