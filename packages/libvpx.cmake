ExternalProject_Add(libvpx
    GIT_REPOSITORY https://chromium.googlesource.com/webm/libvpx.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_TAG 5e680f30801d03c21078f8c4b772464752516211  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 CROSS=${TARGET_ARCH}- <SOURCE_DIR>/configure
        --extra-cflags='-fno-asynchronous-unwind-tables'
        --target=${libvpx_target}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-examples
        --disable-docs
        --disable-tools
        --disable-unit-tests
        --disable-decode-perf-tests
        --disable-encode-perf-tests
        --as=yasm
        --enable-debug
        --enable-vp9-highbitdepth
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libvpx)
cleanup(libvpx install)
