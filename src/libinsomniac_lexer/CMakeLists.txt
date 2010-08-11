

# setup flex
#find_package(BISON)
find_package(FLEX)

# flex generates a .h file, it would appear that no one handles this correctly
#set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES	${CMAKE_CURRENT_BINARY_DIR}/lexer.h)

FLEX_TARGET(LEXER lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c) 

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(libinsomnia_lexer
	${FLEX_LEXER_OUTPUTS})

include(${PROJECT_SOURCE_DIR}/CMakeIncludes.txt)
