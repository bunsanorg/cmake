cmake_minimum_required(VERSION 3.0)

include(${CMAKE_SOURCE_DIR}/system-config.cmake OPTIONAL)

project(bunsan_cmake)

# This project is common dependency.
# Other bunsan projects should assume that
# this module is loaded with find_package(BunsanCmake).
include(${CMAKE_SOURCE_DIR}/scripts/module.cmake)

bunsan_bootstrap_module(
    NAME BunsanCMake
    TEMPLATE Modules.cmake.in
    DIRECTORIES scripts/
    FILES
        ConfigureFile.cmake.in
        Modules.cmake.in
        Project.cmake.in
        StaticInitializer.cpp.in
        StaticInitializerCall.cpp.in
)

bunsan_install_project()
