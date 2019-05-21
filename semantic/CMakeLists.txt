cmake_minimum_required(VERSION 3.12)
project(dana_semantic)

set(CMAKE_CXX_STANDARD 14)

FLEX_TARGET(SemScanner semantics/lexer_for_sem.l ${CMAKE_CURRENT_BINARY_DIR}/lexer_for_sem.cpp)

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