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

    set(python_version ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR})

    if(UNIX)
        set(destination lib/python${python_version}/site-packages)
    else()
        message(SEND_ERROR "Environment is not supported.")
    endif()

    set(module_destination ${destination}/${module_path})

    string(REPLACE "/" ";" module_destination_list ${module_destination})
    list(LENGTH module_destination_list length)
    math(EXPR last "${length} - 1")
    list(REMOVE_AT module_destination_list last)
    set(base_rpath "$ORIGIN")
    foreach(part ${module_destination_list})
        set(base_rpath "${base_rpath}/..")
    endforeach()

    set(rpath "${base_rpath};${base_rpath}/../${CMAKE_INSTALL_LIBDIR};${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
endmacro()

function(bunsan_install_python_module_target)
    bunsan_install_python_module_common(TARGET ${ARGN})

    set_target_properties(${ARG_TARGET}
        PROPERTIES
        OUTPUT_NAME ${module_name}
        PREFIX ""
        INSTALL_RPATH "${rpath}"
    )

    install(TARGETS ${ARG_TARGET} DESTINATION ${module_destination})
endfunction()

macro(bunsan_install_python_module_compile)
    foreach(pyfile ${ARGN})
        install(CODE "
            set(pyfile \"\$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/${pyfile}\")
            execute_process(
                COMMAND ${PYTHON_EXECUTABLE} -OO -m py_compile \${pyfile}
                RESULT_VARIABLE result
            )
            if(NOT result EQUAL 0)
                message(SEND_ERROR \"Unable to compile \${pyfile}\")
            endif()
        ")
    endforeach()
endmacro()

function(bunsan_install_python_module_init)
    bunsan_install_python_module_common(INIT ${ARGN})

    install(FILES ${ARG_INIT} DESTINATION ${destination}/${module} RENAME __init__.py)
    bunsan_install_python_module_compile(${destination}/${module}/__init__.py)
endfunction()
