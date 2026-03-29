cmake_minimum_required(VERSION 4.0.0)

project(insomniac C)

enable_language(ASM)

INCLUDE(CTest)

set(UPDATE_TYPE git)

# Set OSX rpath policy
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()

# Generate compile_commands.json for clang-tidy
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# clang-tidy: enforce braces around all control structures
find_program(CLANG_TIDY NAMES clang-tidy)
if(CLANG_TIDY)
  set(CMAKE_C_CLANG_TIDY "${CLANG_TIDY}")
else()
  message(FATAL_ERROR "clang-tidy not found. Install it (e.g. brew install llvm) and ensure it is on PATH.")
endif()

# clang-format targets: `make format` applies, `make format-check` validates
find_program(CLANG_FORMAT NAMES clang-format)
if(NOT CLANG_FORMAT)
  message(FATAL_ERROR "clang-format not found. Install it (e.g. brew install llvm) and ensure it is on PATH.")
endif()

file(GLOB_RECURSE ALL_C_SOURCES
  "${PROJECT_SOURCE_DIR}/src/*.c"
  "${PROJECT_SOURCE_DIR}/src/*.h"
  "${PROJECT_SOURCE_DIR}/test/*.c"
  "${PROJECT_SOURCE_DIR}/test/*.h"
)
# Exclude Bison/Flex generated files (they live in the build tree)
list(FILTER ALL_C_SOURCES EXCLUDE REGEX "${PROJECT_BINARY_DIR}/.*")

add_custom_target(format
  COMMAND ${CLANG_FORMAT} -i ${ALL_C_SOURCES}
  COMMENT "Applying clang-format to all C sources"
)

add_custom_target(format-check
  COMMAND ${CLANG_FORMAT} --dry-run --Werror ${ALL_C_SOURCES}
  COMMENT "Checking clang-format compliance"
)

add_subdirectory(src)

add_subdirectory(test)

ENABLE_TESTING()


