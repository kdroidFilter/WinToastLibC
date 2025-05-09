cmake_minimum_required(VERSION 3.15)

# Set CMP0177 policy to NEW to avoid warnings about install() DESTINATION paths normalization
if(POLICY CMP0177)
  cmake_policy(SET CMP0177 NEW)
endif()

project(WinToastLibC LANGUAGES C CXX)

set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD 90)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set output directory if provided
if(DEFINED OUTPUT_DIR)
    message(STATUS "Output directory: ${OUTPUT_DIR}")
    # Ensure output directory exists
    file(MAKE_DIRECTORY ${OUTPUT_DIR})
else()
    set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/install/bin")
    message(STATUS "Using default output directory: ${OUTPUT_DIR}")
endif()

add_library(
    wintoastlibc
    SHARED
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlib.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlib.h
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.h
)
target_link_libraries(
    wintoastlibc
    shlwapi
    user32
    advapi32
    ole32
)
set_target_properties(
    wintoastlibc
    PROPERTIES
    PUBLIC_HEADER
    "${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.h"
    MSVC_RUNTIME_LIBRARY
    "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    OUTPUT_NAME "wintoastlibc"
    LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG "${OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE "${OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${OUTPUT_DIR}"
)

add_library(
    wintoastlibc_lazy
    SHARED
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc_lazy.c
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.h
)
target_link_libraries(
    wintoastlibc_lazy
    kernel32
)
set_target_properties(
    wintoastlibc_lazy
    PROPERTIES
    PUBLIC_HEADER
    "${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.h"
    OUTPUT_NAME "wintoastlibc_lazy"
    LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG "${OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE "${OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${OUTPUT_DIR}"
)

add_library(
    wintoastlibc_static
    STATIC
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlib.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlib.h
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.h
)
target_compile_definitions(
    wintoastlibc_static
    PUBLIC
    WTLC_BUILD_STATIC
)
target_link_libraries(
    wintoastlibc_static
    shlwapi
    user32
    advapi32
    ole32
)
set_target_properties(
    wintoastlibc_static
    PROPERTIES
    PUBLIC_HEADER
    "${CMAKE_CURRENT_LIST_DIR}/src/wintoastlibc.h"
    OUTPUT_NAME "wintoastlibc_static"
    ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_DIR}"
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${OUTPUT_DIR}"
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${OUTPUT_DIR}"
)

add_executable(
    example1
    WIN32
    ${CMAKE_CURRENT_LIST_DIR}/example/example1.c
)
target_include_directories(
    example1
    PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/src
)
target_link_libraries(
    example1
    wintoastlibc
    ole32
)

add_executable(
    example1_lazy
    WIN32
    ${CMAKE_CURRENT_LIST_DIR}/example/example1.c
)
target_include_directories(
    example1_lazy
    PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/src
)
target_link_libraries(
    example1_lazy
    wintoastlibc_lazy
    ole32
)

add_executable(
    example2
    WIN32
    ${CMAKE_CURRENT_LIST_DIR}/example/example2.c
)
target_include_directories(
    example2
    PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/src
)
target_link_libraries(
    example2
    wintoastlibc_static
    shlwapi
    ole32
)

install(
    TARGETS wintoastlibc wintoastlibc_static wintoastlibc_lazy example1 example2 example1_lazy
    RUNTIME DESTINATION ${OUTPUT_DIR}
    ARCHIVE DESTINATION ${OUTPUT_DIR}
    LIBRARY DESTINATION ${OUTPUT_DIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_BINARY_DIR}/install/include
)
