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
