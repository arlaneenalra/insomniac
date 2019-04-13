
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(libinsomniac_vm_instructions)

add_library(insomniac_vm
  vm_core.c
  vm_util.c
  vm_types.c
  vm_eval.c
  vm_utf8.c
  vm_output.c
  vm_alloc.c
  vm_env.c
  )

target_link_libraries(insomniac_vm
  insomniac_vm_instructions
  )

