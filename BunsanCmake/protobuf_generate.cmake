# TODO refactoring needed
function(bunsan_protobuf_generate_cpp)
    set(options)
    set(one_value_args HEADERS SOURCES INSTALL)
    set(multi_value_args PROTOS)
    cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    set(proto_src ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set(proto_dst ${CMAKE_CURRENT_BINARY_DIR}/bunsan_protobuf)
    include_directories(${proto_dst})
    set(srcs_)
    set(hdrs_)
    set(protos_)
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
        OUTPUT ${hdrs_} ${srcs_}
        COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} --cpp_out=${proto_dst} ${proto_paths} ${protos_}
        DEPENDS ${protos_} ${proto_dst}
    )
    set(${ARG_SOURCES} ${srcs_} PARENT_SCOPE)
    set(${ARG_HEADERS} ${hdrs_} PARENT_SCOPE)
endfunction()
