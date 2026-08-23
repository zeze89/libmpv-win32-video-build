ExternalProject_Add(opusfile
    DEPENDS
        opus
    GIT_REPOSITORY https://github.com/xiph/opusfile.git
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
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/autogen.sh && CONF=1 <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-doc
        --disable-examples
        --disable-http
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(opusfile)
cleanup(opusfile install)
