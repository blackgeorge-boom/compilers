cmake_minimum_required(VERSION 3.12)
project(dana_llvm)

set(CMAKE_CXX_STANDARD 14)

include_directories(${CMAKE_CURRENT_LIST_DIR})

find_package(FLEX)
find_package(BISON)
find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

FLEX_TARGET(Scanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

## No Offside Rule
BISON_TARGET(ParserU parser_unindent.y ${CMAKE_CURRENT_BINARY_DIR}/parser_u.cpp)
## Offside Rule
BISON_TARGET(ParserI parser_indent.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
ADD_FLEX_BISON_DEPENDENCY(Scanner ParserU)
ADD_FLEX_BISON_DEPENDENCY(Scanner ParserI)

add_executable(dana_compiler ${BISON_ParserU_OUTPUTS} ${FLEX_Scanner_OUTPUTS} ast.cpp ast.h error.c error.h general.c
               general.h symbol.c symbol.h auxiliary.cpp auxiliary.h logger.cpp logger.h ast_sem.cpp ast_sem.h
               our_libs.c)
add_executable(dana_compiler_indent ${BISON_ParserI_OUTPUTS} ${FLEX_Scanner_OUTPUTS} ast.cpp ast.h error.c error.h general.c
               general.h symbol.c symbol.h auxiliary.cpp auxiliary.h logger.cpp logger.h ast_sem.cpp ast_sem.h
               our_libs.c)

# Set the path to the library folder
link_directories(/usr/lib/x86_64-linux-gnu/)

llvm_map_components_to_libnames(llvm_libs support core irreader mcjit native)

# Same as compiling with -lfl flag
target_link_libraries(dana_compiler fl.a ${llvm_libs})
target_link_libraries(dana_compiler_indent fl.a ${llvm_libs})
