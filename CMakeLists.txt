
project(insomniac C)

cmake_minimum_required(VERSION 2.8.1)

enable_language(ASM)

INCLUDE(CTest)

set(UPDATE_TYPE git)

# Set OSX rpath policy
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()

add_subdirectory(src)

add_subdirectory(test)

add_subdirectory(core)

ENABLE_TESTING()


