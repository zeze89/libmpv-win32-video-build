ExternalProject_Add(highway
    GIT_REPOSITORY https://github.com/google/highway.git
    GIT_TAG f2e75e3489f5530d5a3198a07d2df9d425265407  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dcontrib=disabled
        -Dexamples=disabled
        -Dtests=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(highway)
force_meson_configure(highway)
cleanup(highway install)
