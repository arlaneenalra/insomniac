
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(insomniac_runtime
    runtime_core.c
)

target_link_libraries(insomniac_runtime
    insomniac_buffer
    insomniac_vm
    insomniac_hash
    insomniac_gc
)


