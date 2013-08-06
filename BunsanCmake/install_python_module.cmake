function(bunsan_install_python_module)
    set(options)
    set(one_value_args TARGET MODULE)
    set(multi_value_args)
    cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    if(NOT ARG_TARGET)
        message(SEND_ERROR "You must provide TARGET option.")
    endif()
    set(target ${ARG_TARGET})
    if(ARG_MODULE)
        set(module ${ARG_MODULE})
    else()
        set(module ${target})
    endif()

    string(REPLACE "." "/" module ${module})
    get_filename_component(module_name ${module} NAME)
    get_filename_component(module_path ${module} PATH)

    set_target_properties(${target}
        PROPERTIES
        OUTPUT_NAME ${module_name}
        PREFIX ""
    )

    list(LENGTH PYTHON_LIBRARIES python_libraries_length)
    if(NOT python_libraries_length EQUAL 1)
        message(SEND_ERROR "PYTHON_LIBRARIES variable should contain exactly one module.")
    endif()

    get_filename_component(libprefix ${PYTHON_LIBRARIES} PATH)
    string(REPLACE "." ";" python_version_list "${PYTHONLIBS_VERSION_STRING}")
    list(GET python_version_list 0 python_version_major)
    list(GET python_version_list 1 python_version_minor)

    if(UNIX)
        set(destination ${libprefix}/python${python_version_major}.${python_version_minor}/site-packages)
    else()
        message(SEND_ERROR "Environment is not supported.")
    endif()

    install(TARGETS ${target} DESTINATION ${destination}/${module_path})
endfunction()
