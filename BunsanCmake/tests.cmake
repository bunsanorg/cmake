macro(bunsan_include_tests)
    if(ENABLE_TESTS)
        enable_testing()
        add_subdirectory(tests ${CMAKE_CURRENT_BINARY_DIR}/tests)
    endif()
endmacro()

# exports ${bunsan_tests_sources} and ${bunsan_tests_targets}
macro(bunsan_tests_project)
    project(${PROJECT_NAME}_tests)

    cmake_minimum_required(VERSION 2.8)

    message("tests were included")

    bunsan_use_boost(unit_test_framework)

    aux_source_directory(. bunsan_tests_sources)

    add_definitions(-DBOOST_TEST_DYN_LINK)

    set(test_env
        "BUNSAN_SOURCE_DIR=${CMAKE_SOURCE_DIR}"
        "BUNSAN_BINARY_DIR=${CMAKE_BINARY_DIR}"
    )

    set(bunsan_tests_targets)

    foreach(src ${bunsan_tests_sources})
        string(REGEX REPLACE "^.*/([^/]+)\\.cpp$" "\\1" trgt ${src})
        add_executable(test_${trgt} ${src})
        target_link_libraries(test_${trgt} ${CMAKE_PROJECT_NAME} ${libraries})
        add_test(${trgt} test_${trgt})
        set_tests_properties(${trgt} PROPERTIES ENVIRONMENT "${test_env}")
        list(APPEND bunsan_tests_targets ${trgt})
    endforeach()

    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/resources)
        add_subdirectory(resources ${CMAKE_CURRENT_BINARY_DIR}/resources)
    endif()
endmacro()
