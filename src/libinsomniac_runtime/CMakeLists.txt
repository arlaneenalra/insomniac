
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

link_directories(
    ${libinsomniac_vm_BIN_DIR}/libinsomniac_vm
    ${libinsomniac_gc_BIN_DIR}/libinsomniac_gc
    ${libinsomniac_buffer_BIN_DIR}/libinsomniac_buffer
    ${libinsomniac_hash_BIN_DIR}/libinsomniac_hash
)

add_library(insomniac_runtime
    runtime_core.c
)

target_link_libraries(insomniac_runtime
    insomniac_buffer
    insomniac_vm
    insomniac_hash
    insomniac_gc
)


