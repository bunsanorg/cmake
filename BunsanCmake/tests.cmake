macro(bunsan_include_tests)
    if(ENABLE_TESTS)
        enable_testing()
        add_subdirectory(tests ${CMAKE_CURRENT_BINARY_DIR}/tests)
    endif()
endmacro()

# exports empty ${bunsan_tests_targets},
# ${bunsan_tests_sources} and ${bunsan_tests}
macro(bunsan_tests_project_header)
    project(${PROJECT_NAME}_tests)

    cmake_minimum_required(VERSION 2.8)

    message("tests were included")

    bunsan_use_boost(unit_test_framework)

    add_definitions(-DBOOST_TEST_DYN_LINK)

    set(test_env
        "BUNSAN_SOURCE_DIR=${CMAKE_SOURCE_DIR}"
        "BUNSAN_BINARY_DIR=${CMAKE_BINARY_DIR}"
    )

    set(bunsan_tests)
    set(bunsan_tests_sources)
    set(bunsan_tests_targets)
endmacro()

# updates ${bunsan_tests_targets},
# ${bunsan_tests_sources} and ${bunsan_tests}
macro(bunsan_tests_project_add_executable target)
    add_executable(${target} ${ARGN})
    target_link_libraries(${target} ${CMAKE_PROJECT_NAME} ${libraries})
    list(APPEND bunsan_tests_sources ${ARGN})
    list(APPEND bunsan_tests_targets ${target})
endmacro()

# updates ${bunsan_tests}
macro(bunsan_tests_project_add_custom_test test)
    add_test(${test} ${ARGN})
    set_tests_properties(${test} PROPERTIES ENVIRONMENT "${test_env}")
    list(APPEND bunsan_tests ${test})
endmacro()

# updates ${bunsan_tests_targets},
# ${bunsan_tests_sources} and ${bunsan_tests}
macro(bunsan_tests_project_add_test target)
    bunsan_tests_project_add_executable(test_${target} ${ARGN})
    bunsan_tests_project_add_custom_test(${target} test_${target} ${ARGN})
endmacro()

# updates ${bunsan_tests_targets} and empty ${bunsan_tests_sources}
macro(bunsan_tests_project_aux_add_tests)
    aux_source_directory(. bunsan_tests_aux_sources)

    foreach(source ${bunsan_tests_aux_sources})
        get_filename_component(target ${source} NAME_WE)
        bunsan_tests_project_add_test(${target} ${source})
    endforeach()
endmacro()

macro(bunsan_tests_project_footer)
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/resources)
        add_subdirectory(resources ${CMAKE_CURRENT_BINARY_DIR}/resources)
    endif()
endmacro()

# exports ${bunsan_tests_sources} and ${bunsan_tests_targets}
macro(bunsan_tests_project)
    bunsan_tests_project_header()
    bunsan_tests_project_aux_add_tests()
    bunsan_tests_project_footer()
endmacro()
