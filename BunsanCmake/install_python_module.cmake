macro(bunsan_install_python_module_common source_arg)
    set(options)
    set(one_value_args ${source_arg} MODULE)
    set(multi_value_args)
    cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    if(ARG_MODULE)
        set(module ${ARG_MODULE})
    else()
        message(SEND_ERROR "MODULE is not set.")
    endif()
    if(NOT ARG_${source_arg})
        message(SEND_ERROR "${source_arg} is not set.")
    endif()

    string(REPLACE "." "/" module ${module})
    get_filename_component(module_name ${module} NAME)
    get_filename_component(module_path ${module} PATH)

    string(REPLACE "." ";" python_version_list "${PYTHONLIBS_VERSION_STRING}")
    list(GET python_version_list 0 python_version_major)
    list(GET python_version_list 1 python_version_minor)

    if(UNIX)
        set(destination ${CMAKE_INSTALL_LIBDIR}/python${python_version_major}.${python_version_minor}/site-packages)
    else()
        message(SEND_ERROR "Environment is not supported.")
    endif()

    set(module_destination ${destination}/${module_path})
endmacro()

function(bunsan_install_python_module_target)
    bunsan_install_python_module_common(TARGET ${ARGN})

    set_target_properties(${ARG_TARGET}
        PROPERTIES
        OUTPUT_NAME ${module_name}
        PREFIX ""
    )

    install(TARGETS ${ARG_TARGET} DESTINATION ${module_destination})
endfunction()

function(bunsan_install_python_module_init)
    bunsan_install_python_module_common(INIT ${ARGN})

    install(FILES ${ARG_INIT} DESTINATION ${destination}/${module} RENAME __init__.py)
endfunction()
