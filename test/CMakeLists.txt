
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)


add_executable(test_hash
  test_hash.c
  )

target_link_libraries(test_hash
  libinsomniac_gc
  libinsomniac_hash
  )


add_test(TestHash ${CMAKE_CURRENT_BIN_DIR}/test_hash)