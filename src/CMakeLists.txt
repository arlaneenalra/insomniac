
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

add_subdirectory(libinsomniac_vm)
add_subdirectory(libinsomniac_gc)
add_subdirectory(libinsomniac_buffer)
add_subdirectory(libinsomniac_hash)
add_subdirectory(libinsomniac_asm)
add_subdirectory(libinsomniac_io)
add_subdirectory(libinsomniac_bootstrap)
add_subdirectory(libinsomniac_runtime)

add_executable( insomniac
    main.c
)

target_link_libraries(insomniac
    insomniac_buffer
    insomniac_vm
    insomniac_hash
    insomniac_gc
    insomniac_asm
)

add_executable(insc-bootstrap
    compiler.c
)

target_link_libraries(insc-bootstrap
    insomniac_bootstrap
    insomniac_buffer
    insomniac_gc
    insomniac_asm
    insomniac_hash
)

