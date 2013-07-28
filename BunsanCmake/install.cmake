set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")

macro(bunsan_install_targets)
    install(TARGETS ${ARGN}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)
endmacro()

macro(bunsan_install_headers)
    install(DIRECTORY include DESTINATION .)
endmacro()
