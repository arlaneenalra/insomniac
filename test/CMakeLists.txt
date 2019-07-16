
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

file(GLOB TEST_LEXER_SOURCES
    ${PROJECT_SOURCE_DIR}/src/core/lexer/*.scm
    ${PROJECT_SOURCE_DIR}/src/core/scheme/*.scm)

set(test_core_matchers_EXTRA ${TEST_LEXER_SOURCES})
set(test_core_stream_EXTRA ${TEST_LEXER_SOURCES})
set(test_core_token_EXTRA ${TEST_LEXER_SOURCES})
set(test_core_lexer_EXTRA ${TEST_LEXER_SOURCES})

# Setup and build scheme tests.
file(GLOB SCM_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} test_*.scm)

foreach(SCM_FILE ${SCM_SOURCES})
    string(REPLACE ".scm" "" testname ${SCM_FILE})

    INSC_TARGET(TEST_SCM ${SCM_FILE} ${testname} ${${testname}_EXTRA})

    
    add_test(Test_${testname} ${INSC_TEST_SCM_OUTPUT})
endforeach()

