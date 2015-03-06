set(BUILD_SHARED_LIBS ON CACHE BOOL "Build shared libraries")

macro(bunsan_targets_finish_setup)
    foreach(target ${ARGN})
        if(EXISTS ${CMAKE_SOURCE_DIR}/include)
            target_include_directories(${target} PRIVATE ${CMAKE_SOURCE_DIR}/include)
            target_include_directories(
                ${target}
                INTERFACE
                    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            )
        endif()
    endforeach()
endmacro()

function(bunsan_add_executable target)
    add_executable(${target} ${ARGN})
endfunction()

function(bunsan_add_library target)
    add_library(${target} ${ARGN})
endfunction()

function(bunsan_add_shared_library target)
    bunsan_add_library(${target} SHARED ${ARGN})
endfunction()

function(bunsan_add_static_library target)
    bunsan_add_library(${target} STATIC ${ARGN})
endfunction()
