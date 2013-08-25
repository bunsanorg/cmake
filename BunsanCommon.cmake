# compiler
if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-std=c++11 -Wall -Wextra -Wno-multichar")
    if(UNIX)
        set(CMAKE_CXX_FLAGS "-rdynamic -pthread ${CMAKE_CXX_FLAGS}")
    endif()
    set(CMAKE_CXX_FLAGS_DEBUG "-g")
    set(CMAKE_CXX_FLAGS_RELEASE "-O2")
endif()

if(CMAKE_COMPILER_IS_GNUCC)
    set(CMAKE_C_FLAGS "-std=c11 -Wall -Wextra")
    if(UNIX)
        set(CMAKE_C_FLAGS "-rdynamic -pthread ${CMAKE_C_FLAGS}")
    endif()
    set(CMAKE_C_FLAGS_DEBUG "-g")
    set(CMAKE_C_FLAGS_RELEASE "-O2")
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUCC)
    set(linker_flags "-Wl,--no-as-needed") # for bunsan::factory plugins
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${linker_flags}")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${linker_flags}")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${linker_flags}")
endif()

include(${CMAKE_SOURCE_DIR}/user-config.cmake OPTIONAL)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: Debug Release" FORCE)
endif()

if(NOT DEFINED ENABLE_TESTS)
    set(ENABLE_TESTS ON CACHE BOOL "Do you want to enable testing?" FORCE)
endif()

if(EXISTS ${CMAKE_SOURCE_DIR}/include)
    include_directories(include)
endif()

# plugin functions
macro(bunsan_install_plugins)
    foreach(arg ${ARGN})
        if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/${arg})
            install(DIRECTORY ${arg}/ DESTINATION ${CMAKE_ROOT}/Modules/BunsanCmake)
        else()
            install(FILES ${arg} DESTINATION ${CMAKE_ROOT}/Modules/BunsanCmake)
        endif()
    endforeach()
endmacro()

macro(bunsan_load_plugins)
    foreach(dir ${ARGN})
        message("Loading plugins from ${dir}")
        file(GLOB plugins ${dir}/*.cmake)
        foreach(plugin ${plugins})
            message("Loading ${plugin}")
            include(${plugin})
        endforeach()
    endforeach()
endmacro()

macro(bunsan_load_available_plugins)
    foreach(module_path ${CMAKE_ROOT}/Modules ${CMAKE_MODULE_PATH})
        bunsan_load_plugins(${module_path}/BunsanCmake)
    endforeach()
endmacro()
# end plugin functions

bunsan_load_available_plugins()
