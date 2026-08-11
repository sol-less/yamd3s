cmake_minimum_required(VERSION 3.21)
project(Y3s LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick)

add_subdirectory(lib)
add_subdirectory(tokens)
add_subdirectory(globals)
