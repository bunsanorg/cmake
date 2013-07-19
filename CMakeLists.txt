project(bunsan_cmake)

include(${CMAKE_SOURCE_DIR}/system-config.cmake OPTIONAL)

cmake_minimum_required(VERSION 2.6)

# This project is common dependency.
# Other bunsan projects should assume that
# this module is installed system-wide.
include(${CMAKE_SOURCE_DIR}/BunsanCommon.cmake)

install(FILES BunsanCommon.cmake DESTINATION ${CMAKE_ROOT}/Modules)
install(DIRECTORY Modules/ DESTINATION ${CMAKE_ROOT}/Modules)
bunsan_install_plugins(BunsanCmake)
