cmake_minimum_required(VERSION 3.12)
project(dana_semantic)

set(CMAKE_CXX_STANDARD 14)

include_directories(${CMAKE_CURRENT_LIST_DIR})

find_package(FLEX)
find_package(BISON)

FLEX_TARGET(Scanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)

## No Offside Rule
BISON_TARGET(ParserU parser_unindent.y ${CMAKE_CURRENT_BINARY_DIR}/parser_u.c)
## Offside Rule
BISON_TARGET(ParserI parser_indent.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
ADD_FLEX_BISON_DEPENDENCY(Scanner ParserU)
ADD_FLEX_BISON_DEPENDENCY(Scanner ParserI)

add_executable(parser_u ${BISON_ParserU_OUTPUTS} ${FLEX_Scanner_OUTPUTS} ast.c ast.h error.c error.h general.c general.h symbol.c symbol.h)
add_executable(parser_i ${BISON_ParserI_OUTPUTS} ${FLEX_Scanner_OUTPUTS} ast.c ast.h error.c error.h general.c general.h symbol.c symbol.h)

# Set the path to the library folder
link_directories(/usr/lib/x86_64-linux-gnu/)

# Same as compiling with -lfl flag
target_link_libraries(parser_u fl.a)
target_link_libraries(parser_i fl.a)

