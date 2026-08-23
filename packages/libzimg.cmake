get_property(src_graphengine TARGET graphengine PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(libzimg
    DEPENDS
        graphengine
    GIT_REPOSITORY https://github.com/sekrit-twc/zimg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    # Baglanti KENDINI ONARIR: symlink bir kosuda yok olmus, make eksik
    # yolu GERCEK klasor olarak yaratmisti (32645154669 sondasi kanitladi;
    # icinde yalniz filter_validation vardi). Ayni onarim build ve install
    # oncesinde de kosuyor, cunku damgalar gecerliyken configure atlanir.
    COMMAND bash -c "rm -rf <SOURCE_DIR>/graphengine && ln -s ${src_graphengine} <SOURCE_DIR>/graphengine"
    COMMAND ${EXEC} <SOURCE_DIR>/autogen.sh && CONF=1 <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND bash -c "rm -rf <SOURCE_DIR>/graphengine && ln -s ${src_graphengine} <SOURCE_DIR>/graphengine"
    COMMAND ${MAKE}
    INSTALL_COMMAND bash -c "rm -rf <SOURCE_DIR>/graphengine && ln -s ${src_graphengine} <SOURCE_DIR>/graphengine"
    COMMAND ${MAKE} install
            # .git yoksa git YUKARI yuruyup workspace deposunu bulur ve
            # clean -dfx TUM izlenmeyenleri (src_packages dahil) supurur.
            # graphengine agacinin bos kalmasinin muhtemel sebebi bu
            # (32643884491: cpuinfo.cpp yok). Guard sart, semicolonsuz.
            COMMAND bash -c "[ -e ${src_graphengine}/.git ] && git -C ${src_graphengine} clean -dfx || true"
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libzimg)
cleanup(libzimg install)
