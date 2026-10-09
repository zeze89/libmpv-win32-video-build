ExternalProject_Add(xz
    GIT_REPOSITORY https://github.com/tukaani-project/xz.git
    GIT_TAG 3b1efb04d17c3a9ef7f473d73af13f1531428ffe  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_RESET 3d078b52adbff566ccfc51067dfbf742ecf3ef86 # v5.8.2
    CONFIGURE_COMMAND ${EXEC} CONF=1 autoreconf -fi && <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-xz
        --disable-xzdec
        --disable-lzmadec
        --disable-lzmainfo
        --disable-doc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(xz)
cleanup(xz install)
