
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(insomniac_vm
  vm_core.c
  vm_util.c
  vm_types.c
  vm_eval.c
  vm_ops.c
  vm_utf8.c
  vm_output.c
  vm_alloc.c
  vm_env.c
  )
