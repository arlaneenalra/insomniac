cmake_minimum_required(VERSION 4.0.0)

project(insomniac C)

enable_language(ASM)

INCLUDE(CTest)

set(UPDATE_TYPE git)

# Set OSX rpath policy
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()

add_subdirectory(src)

add_subdirectory(test)

ENABLE_TESTING()


