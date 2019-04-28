
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

# Setup and build scheme tests.
file(GLOB SCM_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} test_*.scm)

foreach(SCM_FILE ${SCM_SOURCES})
    string(REPLACE ".scm" "" testname ${SCM_FILE})

    INSC_TARGET(TEST_SCM ${SCM_FILE} ${SCM_FILE}.s)

    add_executable(${testname}
        ${INSC_TEST_SCM_OUTPUTS}
        )

    set_target_properties(${testname}
        PROPERTIES LINKER_LANGUAGE C
        )

    target_link_libraries(${testname}
        insomniac_runtime
        )

    add_test(Test_${testname} ${CMAKE_CURRENT_BIN_DIR}/${testname})
endforeach()

