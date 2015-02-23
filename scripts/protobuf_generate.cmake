# TODO refactoring needed
include(${CMAKE_CURRENT_LIST_DIR}/install_dirs.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/libraries.cmake)

macro(bunsan_protobuf_get_target_includes includes target)
    get_target_property(${includes} ${target} INTERFACE_INCLUDE_DIRECTORIES)
    if(NOT includes)
        set(includes)
    endif()
endmacro()

macro(bunsan_protobuf_get_target_libraries libraries target)
    get_target_property(${libraries} ${target} INTERFACE_LINK_LIBRARIES)
    if(NOT libraries)
        set(libraries)
    endif()
endmacro()

macro(bunsan_protobuf_append_proto_paths var)
    foreach(proto_path ${ARGN})
        list(APPEND ${var} --proto_path=${proto_path})
    endforeach()
endmacro()

macro(bunsan_protobuf_include_directories target visibility)
    if(${ARGC} GREATER 0)
        target_include_directories(${target} ${visibility} ${ARGN})
    endif()
endmacro()

macro(bunsan_protobuf_link_libraries target visibility)
    if(${ARGC} GREATER 0)
        target_link_libraries(${target} ${visibility} ${ARGN})
    endif()
endmacro()

function(bunsan_protobuf_get_libraries_proto_paths proto_paths)
    foreach(library ${ARGN})
        if(TARGET ${library})
            bunsan_protobuf_get_target_includes(includes ${library})
            bunsan_protobuf_append_proto_paths(proto_paths_ ${includes})
            bunsan_protobuf_get_target_libraries(libraries ${library})
            list(LENGTH libraries length)
            if(${length} GREATER 0)
                bunsan_protobuf_get_libraries_proto_paths(paths ${libraries})
                list(APPEND proto_paths_ ${paths})
            endif()
        endif()
    endforeach()
    set(${proto_paths} ${proto_paths_} PARENT_SCOPE)
endfunction()

function(bunsan_add_protobuf_cxx_library)
    bunsan_find_package(Protobuf REQUIRED)

    string(SHA1 call_hash "${ARGN}")
    set(options INSTALL STATIC SHARED)
    set(one_value_args
        TARGET
        HEADERS SOURCES DESCRIPTOR_SET DESCRIPTOR_SET_FILENAME
        INCLUDE_DIRECTORIES LIBRARIES
    )
    set(multi_value_args PROTOS)
    cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    set(proto_src ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set(proto_dst ${CMAKE_CURRENT_BINARY_DIR}/bunsan_protobuf)
    set(srcs_)
    set(hdrs_)
    set(protos_)

    if(ARG_STATIC)
        set(libtype STATIC)
    elseif(ARG_SHARED)
        set(libtype SHARED)
    endif()

    # compose descriptor set
    set(descriptor_set_dir ${proto_dst}/${call_hash})
    if(ARG_DESCRIPTOR_SET_FILENAME)
        set(descriptor_set_ ${ARG_DESCRIPTOR_SET_FILENAME})
    else()
        set(descriptor_set_ "descriptor_set_${call_hash}.pb")
    endif()
    set(descriptor_set_ ${descriptor_set_dir}/${descriptor_set_})

    # compose sources and results
    foreach(proto ${ARG_PROTOS})
        get_filename_component(filename_we ${proto} NAME_WE)
        get_filename_component(dirname ${proto} PATH)
        set(path_we ${dirname}/${filename_we})
        set(hdr ${proto_dst}/${path_we}.pb.h)
        set(src ${proto_dst}/${path_we}.pb.cc)
        set(prt ${proto_src}/${proto})
        list(APPEND hdrs_ ${hdr})
        list(APPEND srcs_ ${src})
        list(APPEND protos_ ${prt})
        if(ARG_INSTALL)
            install(FILES ${hdr}
                    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${dirname})
        endif()
    endforeach()

    # compose includes
    set(proto_paths)
    bunsan_protobuf_append_proto_paths(proto_paths
        ${ARG_INCLUDE_DIRECTORIES}
        ${CMAKE_SOURCE_DIR}/include # bunsan project layout
        ${proto_dst}
    )
    bunsan_protobuf_get_libraries_proto_paths(proto_paths_ ${ARG_LIBRARIES})
    list(APPEND proto_paths ${proto_paths_})

    # generate
    bunsan_create_directories(${proto_dst} ${descriptor_set_dir})
    add_custom_command(
        OUTPUT ${hdrs_} ${srcs_} ${descriptor_set_}
        COMMAND ${PROTOBUF_PROTOC_EXECUTABLE}
            --cpp_out=${proto_dst} --descriptor_set_out=${descriptor_set_}
            ${proto_paths} ${protos_}
        DEPENDS ${protos_}
    )

    # main target
    bunsan_add_library(${ARG_TARGET} ${libtype} ${hdrs_} ${srcs_})
    bunsan_protobuf_include_directories(${ARG_TARGET}
        PUBLIC
            ${Protobuf_INCLUDE_DIRECTORIES}
            ${ARG_INCLUDE_DIRECTORIES}
            $<BUILD_INTERFACE:${proto_dst}>
    )
    bunsan_protobuf_link_libraries(${ARG_TARGET}
        PUBLIC
            ${Protobuf_LIBRARIES}
            ${ARG_LIBRARIES}
    )

    # exports
    if(ARG_HEADERS)
        set(${ARG_HEADERS} ${hdrs_} PARENT_SCOPE)
    endif()
    if(ARG_SOURCES)
        set(${ARG_SOURCES} ${srcs_} PARENT_SCOPE)
    endif()
    if(ARG_DESCRIPTOR_SET)
        set(${ARG_DESCRIPTOR_SET} ${descriptor_set_} PARENT_SCOPE)
    endif()
    if(ARG_INSTALL)
        bunsan_install_targets(${ARG_TARGET})
    endif()
endfunction()
