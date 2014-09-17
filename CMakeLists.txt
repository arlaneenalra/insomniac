
project(insomniac C)

cmake_minimum_required(VERSION 3.0.1)

INCLUDE(CTest)

set(UPDATE_TYPE git)

add_subdirectory(src)

add_subdirectory(test)

ENABLE_TESTING()



