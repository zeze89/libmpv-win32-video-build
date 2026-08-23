ExternalProject_Add(vorbis
    DEPENDS
        ogg
    GIT_REPOSITORY https://github.com/xiph/vorbis.git
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
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(vorbis)
cleanup(vorbis install)
