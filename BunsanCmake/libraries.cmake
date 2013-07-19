macro(bunsan_use)
    list(APPEND libraries ${ARGN})
endmacro()

macro(bunsan_use_boost)
    set(Boost_USE_STATIC_LIBS OFF)
    set(Boost_USE_MULTITHREADED ON)
    find_package(Boost COMPONENTS ${ARGN} REQUIRED)
    include_directories(${Boost_INCLUDE_DIRS})
    bunsan_use(${Boost_LIBRARIES})
endmacro()

macro(bunsan_use_xmlrpc)
    find_package(XMLRPC REQUIRED ${ARGN})
    include_directories(${XMLRPC_INCLUDE_DIRS})
    bunsan_use(${XMLRPC_LIBRARIES})
endmacro()

macro(bunsan_use_curl)
    find_package(CURL REQUIRED)
    include_directories(${CURL_INCLUDE_DIRS})
    bunsan_use(${CURL_LIBRARIES})
endmacro()

macro(bunsan_use_bunsan)
    foreach(lib ${ARGN})
        bunsan_use(bunsan_${lib})
    endforeach()
endmacro()

macro(bunsan_use_protobuf)
    find_package(Protobuf REQUIRED)
    include_directories(${PROTOBUF_INCLUDE_DIRS})
    bunsan_use(${PROTOBUF_LIBRARIES})
endmacro()