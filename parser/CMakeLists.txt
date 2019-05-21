cmake_minimum_required(VERSION 3.12)
project(dana_parser)

set(CMAKE_CXX_STANDARD 14)

find_package(FLEX)
find_package(BISON)

# Set the path to the library folder
link_directories(/usr/lib/x86_64-linux-gnu/)

FLEX_TARGET(ParseScanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

## No Offside Rule
BISON_TARGET(ParserU parser_unindent.y ${CMAKE_CURRENT_BINARY_DIR}/parser_u.cpp)

ADD_FLEX_BISON_DEPENDENCY(ParseScanner ParserU)

add_executable(parser_u ${BISON_ParserU_OUTPUTS} ${FLEX_ParseScanner_OUTPUTS})

# Same as compiling with -lfl flag
target_link_libraries(parser_u fl.a)

## Offside Rule
BISON_TARGET(ParserI parser_indent.y ${CMAKE_CURRENT_BINARY_DIR}/parser_i.cpp)

ADD_FLEX_BISON_DEPENDENCY(ParseScanner ParserI)

add_executable(parser_i ${BISON_ParserI_OUTPUTS} ${FLEX_ParseScanner_OUTPUTS})

# Same as compiling with -lfl flag
target_link_libraries(parser_i fl.a)
