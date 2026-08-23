ExternalProject_Add(opus
    GIT_REPOSITORY https://github.com/xiph/opus.git
    # VARSAYILAN DAL DEGISTI (Nightmare TV, 2026-08-22).
    # GIT_TAG yoktu; CMake o durumda `master` varsayar ve bu depo
    # varsayilan dalini `main` yapmis:
    #   fatal: invalid reference: master
    # Indirme dususu tek pakete kalmiyor: `ninja download` ilk hatada
    # duruyor, sonraki paketler hic inmiyor ve guncelleme asamasi
    # olmayan kaynaklarda git'i yukari yuruttuyor.
    # Tarifin niyeti varsayilan dali almakti; adi guncelliyoruz.
    GIT_TAG main
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dhardening=false
        -Dextra-programs=disabled
        -Dtests=disabled
        -Ddocs=disabled
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(opus)
force_meson_configure(opus)
cleanup(opus install)
