ExternalProject_Add(angle-headers
    GIT_REPOSITORY https://github.com/google/angle.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG 7718b6a1b96c0acf43ff19b1e9222988135f8120  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) main
    GIT_RESET 0cb8023c01f92b29f3738ea7472d06f8f059ed84
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone include/EGL include/KHR"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/EGL ${MINGW_INSTALL_PREFIX}/include/EGL
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/KHR ${MINGW_INSTALL_PREFIX}/include/KHR
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(angle-headers)
cleanup(angle-headers install)
