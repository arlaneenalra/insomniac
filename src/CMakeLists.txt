

add_subdirectory(libinsomniac_parser)


link_directories(${libinsomniac_parser_BIN_DIR}/libinsomniac_parser)

add_executable(insomniac main.c)

target_link_libraries(libinsomniac_parser)

include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

