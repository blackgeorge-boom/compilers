cmake_minimum_required(VERSION 3.12)
project(dana_compiler)

set(CMAKE_CXX_STANDARD 14)

find_package(BISON)
find_package(FLEX)
find_package(LLVM REQUIRED CONFIG)

FLEX_TARGET(Scanner lexer/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
FLEX_TARGET(ParseScanner parser/lexer_for_parser.l ${CMAKE_CURRENT_BINARY_DIR}/lexer_for_parser.cpp)
BISON_TARGET(ParserU parser/parser_unindent.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
#BISON_TARGET(ParserI parser/parser_indent.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
ADD_FLEX_BISON_DEPENDENCY(ParseScanner ParserU)
#ADD_FLEX_BISON_DEPENDENCY(ParseScanner ParserI)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# Set your project compile flags.
# E.g. if using the C++ header files
# you will need to enable C++11 support
# for your compiler.

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

add_executable(lexer ${FLEX_Scanner_OUTPUTS})
add_executable(parser_u ${BISON_ParserU_OUTPUTS} ${FLEX_ParseScanner_OUTPUTS})
#add_executable(parser_i ${BISON_ParserI_OUTPUTS} ${FLEX_ParseScanner_OUTPUTS})
#add_executable(minibasic ${BISON_MyParser_OUTPUTS} ${FLEX_MyScanner_OUTPUTS} ast.cpp ast.hpp)

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs support core irreader mcjit native)

# set the path to the library folder
link_directories(/usr/lib/x86_64-linux-gnu/)

# Link against LLVM libraries
target_link_libraries(lexer fl.a)
target_link_libraries(parser_u fl.a)
#target_link_libraries(parser_i fl.a)
#target_link_libraries(minibasic ${llvm_libs} fl.a)
