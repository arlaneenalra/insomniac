
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

# Something doesn't look right about this
include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/../
  )

add_library(insomniac_vm_instructions
  vm_ops.c
  )

target_link_libraries(
  insomniac_vm_instructions
  )
