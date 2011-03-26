

#add_subdirectory(libinsomniac_parser)
#add_subdirectory(libinsomniac_gc)

link_directories(
                      #  ${libinsomniac_parser_BIN_DIR}/libinsomniac_parser
                      #  ${libinsomniac_gc_BIN_DIR}/libinsomniac_gc
)

add_executable(insomniac 
  main.c
  )

#target_link_libraries(insomniac libinsomniac_parser libinsomniac_gc)

include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)

