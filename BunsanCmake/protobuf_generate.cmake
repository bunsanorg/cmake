# TODO refactoring needed
function(bunsan_protobuf_generate_cpp)
    # cmake 2.6 does not support hashes
    string(RANDOM call_hash)

    set(options)
    set(one_value_args HEADERS SOURCES DESCRIPTOR_SET DESCRIPTOR_SET_FILENAME INSTALL)
    set(multi_value_args PROTOS)
    cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    set(proto_src ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set(proto_dst ${CMAKE_CURRENT_BINARY_DIR}/bunsan_protobuf)
    include_directories(${proto_dst})
    set(srcs_)
    set(hdrs_)
    set(protos_)

    set(descriptor_set_dir ${proto_dst}/${call_hash})
    if(ARG_DESCRIPTOR_SET_FILENAME)
        set(descriptor_set_ ${ARG_DESCRIPTOR_SET_FILENAME})
    else()
        set(descriptor_set_ "descriptor_set_${call_hash}.pb")
    endif()
    set(descriptor_set_ ${descriptor_set_dir}/${descriptor_set_})

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
            install(FILES ${hdr} DESTINATION ${ARG_INSTALL}/${dirname})
        endif()
    endforeach()
    set(proto_paths)
    get_property(includes DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
    # TODO we probably need to append global include dir such as /usr/include
    foreach(proto_path ${includes})
        list(APPEND proto_paths --proto_path=${proto_path})
    endforeach()
    add_custom_command(
        OUTPUT ${proto_dst}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${proto_dst}
    )
    add_custom_command(
        OUTPUT ${descriptor_set_dir}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${descriptor_set_dir}
        DEPENDS ${proto_dst}
    )
    add_custom_command(
        OUTPUT ${hdrs_} ${srcs_} ${descriptor_set_}
        COMMAND ${PROTOBUF_PROTOC_EXECUTABLE}
            --cpp_out=${proto_dst} --descriptor_set_out=${descriptor_set_}
            ${proto_paths} ${protos_}
        DEPENDS ${protos_} ${proto_dst} ${descriptor_set_dir}
    )
    set(${ARG_SOURCES} ${srcs_} PARENT_SCOPE)
    set(${ARG_HEADERS} ${hdrs_} PARENT_SCOPE)
    if(ARG_DESCRIPTOR_SET)
        set(${ARG_DESCRIPTOR_SET} ${descriptor_set_} PARENT_SCOPE)
    endif()
endfunction()
