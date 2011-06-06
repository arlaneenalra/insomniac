
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(libinsomniac_vm
  vm_core.c
  vm_util.c
  vm_types.c
  vm_eval.c
  )
