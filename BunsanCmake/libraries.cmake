macro(bunsan_use)
    list(APPEND libraries ${ARGN})
endmacro()

macro(bunsan_use_package package)
    find_package(${package} REQUIRED ${ARGN})
    string(TOUPPER ${package} _package_upper)
    include_directories(
        ${${package}_INCLUDE_DIRS}
        ${${_package_upper}_INCLUDE_DIRS}
    )
    bunsan_use(
        ${${package}_LIBRARIES}
        ${${_package_upper}_LIBRARIES}
    )
endmacro()

macro(bunsan_use_boost)
    set(Boost_USE_STATIC_LIBS OFF)
    set(Boost_USE_MULTITHREADED ON)
    bunsan_use_package(Boost COMPONENTS ${ARGN})
endmacro()

macro(bunsan_use_xmlrpc)
    bunsan_use_package(XMLRPC ${ARGN})
endmacro()

macro(bunsan_use_curl)
    bunsan_use_package(CURL)
endmacro()

macro(bunsan_use_bunsan)
    foreach(lib ${ARGN})
        bunsan_use(bunsan_${lib})
    endforeach()
endmacro()

macro(bunsan_use_protobuf)
    bunsan_use_package(Protobuf)
endmacro()
