cmake_minimum_required(VERSION 3.12)
project(dana_lexer)

set(CMAKE_CXX_STANDARD 14)

find_package(FLEX)

FLEX_TARGET(Scanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

add_executable(lexer ${FLEX_Scanner_OUTPUTS})

# Set the path to the library folder
link_directories(/usr/lib/x86_64-linux-gnu/)

# Same as compiling with -lfl flag
target_link_libraries(lexer fl.a)

