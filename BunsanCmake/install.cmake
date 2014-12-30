if(EXISTS /etc/arch-release)
    set(CMAKE_INSTALL_SBINDIR bin CACHE PATH "system admin executables (bin)")
    set(CMAKE_INSTALL_LIBEXECDIR lib/${PROJECT_NAME}
        CACHE PATH "program executables (lib/${PROJECT_NAME})")
    set(CMAKE_INSTALL_LIBDIR lib CACHE PATH "object code libraries (lib)")
    mark_as_advanced(
        CMAKE_INSTALL_SBINDIR
        CMAKE_INSTALL_LIBEXECDIR
        CMAKE_INSTALL_LIBDIR)
endif()
include(GNUInstallDirs)

if(NOT DEFINED CMAKE_INSTALL_RPATH)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR};${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}" CACHE STRING
        "A semicolon-separated list specifying the rpath to use in installed targets (for platforms that support it).")
endif()
mark_as_advanced(CMAKE_INSTALL_RPATH)

macro(bunsan_install_targets)
    install(TARGETS ${ARGN}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
endmacro()

macro(bunsan_install_programs)
    install(PROGRAMS ${ARGN} DESTINATION ${CMAKE_INSTALL_BINDIR})
endmacro()

macro(bunsan_install_headers)
    install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endmacro()
