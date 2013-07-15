# compiler
if(${CMAKE_COMPILER_IS_GNUCXX})
    set(gxx_flags "-std=c++11 -Wall -Wextra -Wno-multichar")
    if(${UNIX})
        set(gxx_flags "-rdynamic -pthread ${gxx_flags}")
    endif()
    set(CMAKE_CXX_FLAGS_DEBUG "-g ${gxx_flags}")
    set(CMAKE_CXX_FLAGS_RELEASE "-O2 ${gxx_flags}")
endif()

if(${CMAKE_COMPILER_IS_GNUCC})
    set(gcc_flags "-std=c11 -Wall -Wextra")
    if(${UNIX})
        set(gcc_flags "-rdynamic -pthread ${gcc_flags}")
    endif()
    set(CMAKE_C_FLAGS_DEBUG "-g ${gcc_flags}")
    set(CMAKE_C_FLAGS_RELEASE "-O2 ${gcc_flags}")
endif()

if(${CMAKE_COMPILER_IS_GNUCXX} OR ${CMAKE_COMPILER_IS_GNUCC})
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

# load plugins
file(GLOB plugins ${CMAKE_ROOT}/Modules/BunsanCmake/*.cmake)
foreach(plugin ${plugins})
    include(${plugin})
endforeach()
