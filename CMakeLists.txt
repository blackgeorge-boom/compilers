cmake_minimum_required(VERSION 3.12)
project(dana_compiler)

set(CMAKE_CXX_STANDARD 14)

#############
# Lexer
#############

find_package(FLEX)

FLEX_TARGET(Scanner lexer/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

add_executable(lexer ${FLEX_Scanner_OUTPUTS})

# Set the path to the library folder
link_directories(/usr/lib/x86_64-linux-gnu/)

# Same as compiling with -lfl flag
target_link_libraries(lexer fl.a)

#############
# Parser
#############

find_package(BISON)

FLEX_TARGET(ParseScanner parser/lexer_for_parser.l ${CMAKE_CURRENT_BINARY_DIR}/lexer_for_parser.cpp)

## No Offside Rule
BISON_TARGET(ParserU parser/parser_unindent.y ${CMAKE_CURRENT_BINARY_DIR}/parser_u.cpp)

ADD_FLEX_BISON_DEPENDENCY(ParseScanner ParserU)

add_executable(parser_u ${BISON_ParserU_OUTPUTS} ${FLEX_ParseScanner_OUTPUTS})

target_link_libraries(parser_u fl.a)

## Offside Rule
BISON_TARGET(ParserI parser/parser_indent.y ${CMAKE_CURRENT_BINARY_DIR}/parser_i.cpp)

ADD_FLEX_BISON_DEPENDENCY(ParseScanner ParserI)

add_executable(parser_i ${BISON_ParserI_OUTPUTS} ${FLEX_ParseScanner_OUTPUTS})

target_link_libraries(parser_i fl.a)

#############
# Semantic
#############

#############
# LLVM
#############

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

#add_executable(minibasic ${BISON_MyParser_OUTPUTS} ${FLEX_MyScanner_OUTPUTS} ast.cpp ast.hpp)

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs support core irreader mcjit native)

# Link against LLVM libraries
#target_link_libraries(minibasic ${llvm_libs} fl.a)
