
include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)
include(${PROJECT_SOURCE_DIR}/CMakeTestIncludes.txt)



add_subdirectory(libtester)


add_executable(test_hash
  test_hash.c
  )

target_link_libraries(test_hash
  insomniac_gc
  insomniac_hash
  tester
  )


add_test(TestHash ${CMAKE_CURRENT_BIN_DIR}/test_hash)
