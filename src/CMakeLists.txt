

include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

add_subdirectory(libinsomniac_vm)
add_subdirectory(libinsomniac_gc)
add_subdirectory(libinsomniac_buffer)
add_subdirectory(libinsomniac_hash)
add_subdirectory(libinsomniac_asm)
add_subdirectory(libinsomniac_io)

link_directories(
  ${libinsomniac_vm_BIN_DIR}/libinsomniac_vm
  ${libinsomniac_gc_BIN_DIR}/libinsomniac_gc
  ${libinsomniac_buffer_BIN_DIR}/libinsomniac_buffer
  ${libinsomniac_hash_BIN_DIR}/libinsomniac_hash
  ${libinsomniac_asm_BIN_DIR}/libinsomniac_asm
  )

add_executable( insomniac 
  main.c
  )

target_link_libraries(insomniac 
  libinsomniac_vm
  libinsomniac_gc
  libinsomniac_buffer
  libinsomniac_hash
  libinsomniac_asm
  )


