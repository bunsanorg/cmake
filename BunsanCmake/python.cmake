set(BUNSAN_PYTHON1_VERSIONS 1.6 1.5)
set(BUNSAN_PYTHON2_VERSIONS 2.7 2.6 2.5 2.4 2.3 2.2 2.1 2.0)
set(BUNSAN_PYTHON3_VERSIONS 3.3 3.2 3.1 3.0)

function(bunsan_not_less_version result minimum)
    set(result_)
    foreach(ver ${ARGN})
        if(minimum VERSION_GREATER ver)
            break()
        endif()
        list(APPEND result_ ${ver})
    endforeach()
    set(${result} ${result_} PARENT_SCOPE)
endfunction()

# find python

macro(bunsan_find_python)
    set(Python_ADDITIONAL_VERSIONS ${ARGN})
    find_package(PythonLibs REQUIRED)
    find_package(PythonInterp ${PYTHONLIBS_VERSION_STRING} REQUIRED)
endmacro()

macro(bunsan_find_python1)
    bunsan_find_python(${BUNSAN_PYTHON1_VERSIONS})
endmacro()

macro(bunsan_find_python2)
    bunsan_find_python(${BUNSAN_PYTHON2_VERSIONS})
endmacro()

macro(bunsan_find_python3)
    bunsan_find_python(${BUNSAN_PYTHON3_VERSIONS})
endmacro()

macro(bunsan_find_python_minimum minimum)
    bunsan_not_less_version(bunsan_find_python_minimum_versions ${minimum} ${ARGN})
    bunsan_find_python(${bunsan_find_python_minimum_versions})
endmacro()

macro(bunsan_find_python1_minimum minimum)
    bunsan_find_python_minimum(${minimum} ${BUNSAN_PYTHON1_VERSIONS})
endmacro()

macro(bunsan_find_python2_minimum minimum)
    bunsan_find_python_minimum(${minimum} ${BUNSAN_PYTHON2_VERSIONS})
endmacro()

macro(bunsan_find_python3_minimum minimum)
    bunsan_find_python_minimum(${minimum} ${BUNSAN_PYTHON3_VERSIONS})
endmacro()

# use python libs

macro(bunsan_use_python_libs)
    bunsan_find_python(${ARGN})
    bunsan_use(${PYTHON_LIBRARY})
    include_directories(${PYTHON_INCLUDE_DIR})
endmacro()

macro(bunsan_use_python1_libs)
    bunsan_use_python_libs(${BUNSAN_PYTHON1_VERSIONS})
endmacro()

macro(bunsan_use_python2_libs)
    bunsan_use_python_libs(${BUNSAN_PYTHON2_VERSIONS})
endmacro()

macro(bunsan_use_python3_libs)
    bunsan_use_python_libs(${BUNSAN_PYTHON3_VERSIONS})
endmacro()

macro(bunsan_use_python_libs_minimum minimum)
    bunsan_not_less_version(bunsan_use_python_libs_minimum_versions ${minimum} ${ARGN})
    bunsan_use_python_libs(${bunsan_use_python_libs_minimum_versions})
endmacro()

macro(bunsan_use_python1_libs_minimum minimum)
    bunsan_use_python_libs_minimum(${minimum} ${BUNSAN_PYTHON1_VERSIONS})
endmacro()

macro(bunsan_use_python2_libs_minimum minimum)
    bunsan_use_python_libs_minimum(${minimum} ${BUNSAN_PYTHON2_VERSIONS})
endmacro()

macro(bunsan_use_python3_libs_minimum minimum)
    bunsan_use_python_libs_minimum(${minimum} ${BUNSAN_PYTHON3_VERSIONS})
endmacro()
