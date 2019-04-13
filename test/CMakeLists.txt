
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

add_test(TestSCMBools ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_bools.scm)

add_test(TestSCMeq? ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_eq.scm)

add_test(TestSCMequal? ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_equal.scm)

add_test(TestSCMLists ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_lists.scm)

add_test(TestSCMVectors ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_vectors.scm)

add_test(TestSCMBytevectors ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_byte_vector.scm)

add_test(TestSCMRecords ${PROJECT_SOURCE_DIR}/run.sh
  ${PROJECT_SOURCE_DIR}/test/test_define_record_type.scm)

