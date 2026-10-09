ExternalProject_Add(nvcodec-headers
    GIT_REPOSITORY https://github.com/FFmpeg/nv-codec-headers.git
    GIT_TAG eddcea9e27f6b772057c9b3f87de2cc1737faffc  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR>
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(nvcodec-headers)
cleanup(nvcodec-headers install)
