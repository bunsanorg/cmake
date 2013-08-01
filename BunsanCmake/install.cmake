include(GNUInstallDirs)

set(CMAKE_INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}")

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
