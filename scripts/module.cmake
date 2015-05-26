# This module must support manual loading for bootstrapping.
# All dependencies should be listed explicitly.
include(${CMAKE_CURRENT_LIST_DIR}/install.cmake)

include(CMakePackageConfigHelpers)
include(CMakeParseArguments)

function(bunsan_install_module_)
    set(options)
    set(one_value_args NAME TEMPLATE BOOTSTRAP)
    set(multi_value_args DIRECTORIES FILES SCRIPTS)
    cmake_parse_arguments(MODULE "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    bunsan_get_package_install_path(MODULE_ROOT ${MODULE_NAME})
    set(MODULE_SCRIPTS_DIR ${MODULE_ROOT}/scripts)
    if(MODULE_BOOTSTRAP)
        set(MODULE_BOOTSTRAP "include(\${${MODULE_NAME}_MODULE_SCRIPTS_DIR}/${MODULE_BOOTSTRAP})")
    endif()
    set(MODULE_CONFIG ${MODULE_NAME}Config.cmake)

    configure_package_config_file(
        ${MODULE_TEMPLATE} ${MODULE_CONFIG}
        INSTALL_DESTINATION ${MODULE_ROOT}
        PATH_VARS
            MODULE_ROOT
            MODULE_SCRIPTS_DIR
    )
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${MODULE_CONFIG}
            DESTINATION ${MODULE_ROOT})

    foreach(dir ${MODULE_DIRECTORIES})
        install(DIRECTORY ${dir} DESTINATION ${MODULE_SCRIPTS_DIR})
    endforeach()
    install(FILES ${MODULE_FILES} DESTINATION ${MODULE_ROOT})
    install(FILES ${MODULE_SCRIPTS} DESTINATION ${MODULE_SCRIPTS_DIR})

    configure_file(
        ModuleBuiltin.cmake.in ${MODULE_NAME}Builtin.cmake
        @ONLY
    )
    include(${CMAKE_CURRENT_BINARY_DIR}/${MODULE_NAME}Builtin.cmake)

    # local exports
    file(COPY ${MODULE_DIRECTORIES} ${MODULE_SCRIPTS}
         DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/scripts)
    file(COPY ${MODULE_FILES}
         DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    export(PACKAGE ${MODULE_NAME})
endfunction()

function(bunsan_bootstrap_module)
    bunsan_install_module_(BOOTSTRAP module.cmake ${ARGN})
endfunction()

function(bunsan_install_module)
    bunsan_install_module_(TEMPLATE ${BunsanCMake_MODULE_ROOT}/Module.cmake.in ${ARGN})
endfunction()

macro(bunsan_load_module_scripts)
    foreach(module ${ARGN})
        message("Loading ${module}")
        include(${module})
    endforeach()
endmacro()

macro(bunsan_load_modules)
    foreach(arg ${ARGN})
        if(NOT IS_ABSOLUTE ${arg})
            set(arg ${CMAKE_CURRENT_SOURCE_DIR}/${arg})
        endif()
        if(IS_DIRECTORY ${arg})
            # Make name pretty
            string(REGEX REPLACE "^(.*[^/])/*$" "\\1" dir "${arg}")
            message("Loading modules from ${dir}")
            file(GLOB_RECURSE modules ${dir}/*.cmake)
            bunsan_load_module_scripts(${modules})
        else()
            bunsan_load_module_scripts(${arg})
        endif()
    endforeach()
endmacro()
