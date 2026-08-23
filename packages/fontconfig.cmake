ExternalProject_Add(fontconfig
    DEPENDS
        expat
        freetype2
        zlib
        libiconv
    GIT_REPOSITORY https://gitlab.freedesktop.org/fontconfig/fontconfig.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    # Yamalar upstream'den tazelendi ve su tepede git apply --check ile
    # OLCULEREK dogrulandi (2026-08-23). Fork'un eski yamasi hicbir caga
    # uymuyordu (2022-2024 tarandi); upstream yamayi rebase edip guncel
    # tutuyormus. Sabitleme yamanin dogrulandigi tepeye.
    GIT_RESET 2e1135a5d46eb12da7b63af89bcb3d363feb928c
    GIT_CLONE_FLAGS "--filter=tree:0"
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/fontconfig-*.patch
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Ddoc=disabled
        -Dtests=disabled
        -Dtools=disabled
        -Dcache-build=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(fontconfig)
force_meson_configure(fontconfig)
cleanup(fontconfig install)
