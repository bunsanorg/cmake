function(bunsan_add_executable target)
    add_executable(${target} ${ARGN})
    target_link_libraries(${target} ${libraries})
endfunction()

function(bunsan_add_shared_library target)
    add_library(${target} SHARED ${ARGN})
    target_link_libraries(${target} ${libraries})
endfunction()

function(bunsan_add_cli_targets targets_)
    set(cli_targets)

    foreach(cli ${ARGN})
        set(trgt ${PROJECT_NAME}_${cli})
        list(APPEND cli_targets ${trgt})
        set(cliprefix src/bin/${cli})
        file(GLOB srcs src/bin/${cli}.cpp)
        bunsan_add_executable(${trgt} ${srcs})
    endforeach()

    set(${cli_targets_} ${cli_targets} PARENT_SCOPE)
endfunction()
