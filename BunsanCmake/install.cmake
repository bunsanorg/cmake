set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")

function(bunsan_install_substitute var)
    set(value "${${var}}")
    string(FIND ${value} "%" subvar_token)
    while(NOT subvar_token EQUAL -1)
        string(FIND ${value} "{" open)
        string(FIND ${value} "}" close)
        math(EXPR expected_open ${subvar_token}+1)
        if(NOT open EQUAL expected_open)
            message(SEND_ERROR "Invalid format: expected '{' at ${expected_open} pos in ${value}")
        endif()
        if(NOT open LESS close)
            message(SEND_ERROR "Invalid format: expected '}' after '{' in ${value}")
        endif()
        math(EXPR var_begin ${open}+1)
        math(EXPR var_length ${close}-${open}-1)
        string(LENGTH ${value} length)
        set(prefix_begin 0)
        set(prefix_length ${subvar_token})
        math(EXPR suffix_begin ${close}+1)
        math(EXPR suffix_length ${length}-${suffix_begin})
        string(SUBSTRING ${value} ${var_begin} ${var_length} subvar)
        string(SUBSTRING ${value} ${prefix_begin} ${prefix_length} prefix)
        string(SUBSTRING ${value} ${suffix_begin} ${suffix_length} suffix)
        set(value "${prefix}${CMAKE_INSTALL_${subvar}}${suffix}")
        string(FIND ${value} "%" subvar_token)
    endwhile()
    set(${var} ${value} PARENT_SCOPE)
endfunction()

foreach(dirname_descr_default
        "BINDIR;user executables;bin"
        "SBINDIR;system admin executables;sbin"
        "LIBEXECDIR;program executables;libexec"
        "SYSCONFDIR;read-only single-machine data;etc"
        "SHAREDSTATEDIR;modifiable architecture-independent data;com"
        "LOCALSTATEDIR;modifiable single-machine data;var"
        "LIBDIR;object code libraries;lib"
        "INCLUDEDIR;C header files;include"
        "OLDINCLUDEDIR;C header files for non-gcc;/usr/include"
        "DATAROOTDIR;read-only architecture-independent data root;share"
        "DATADIR;read-only architecture-independent data;%{DATAROOTDIR}"
        "INFODIR;info documentation;%{DATAROOTDIR}/info"
        "LOCALEDIR;locale-dependent data;%{DATAROOTDIR}/locale"
        "MANDIR;man documentation;%{DATAROOTDIR}/man"
        "DOCDIR;documentation root;%{DATAROOTDIR}/doc/${PROJECT_NAME}"
    )
    list(GET dirname_descr_default 0 dirname)
    list(GET dirname_descr_default 1 descr)
    list(GET dirname_descr_default 2 default)
    bunsan_install_substitute(default)
    if(NOT CMAKE_INSTALL_${dirname})
        set(CMAKE_INSTALL_${dirname} ${default} CACHE PATH ${descr} FORCE)
    endif()
endforeach()

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
