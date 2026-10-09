ExternalProject_Add(amf-headers
    GIT_REPOSITORY https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git
    GIT_TAG a4c8f39ae1959c9ca9d56ade35d6a23c52fc77c5  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone amf/public/include"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/amf/public/include/components  ${MINGW_INSTALL_PREFIX}/include/AMF/components
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/amf/public/include/core        ${MINGW_INSTALL_PREFIX}/include/AMF/core
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(amf-headers)
cleanup(amf-headers install)
