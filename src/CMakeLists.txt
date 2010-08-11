

add_subdirectory(libinsomniac_lexer)


link_directories(${libinsomniac_lexer_BIN_DIR}/libinsomniac_lexer)

add_executable(insomniac main.c)

target_link_libraries(libinsomniac_lexer)

include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

