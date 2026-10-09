ExternalProject_Add(libxml2
    DEPENDS
        zlib
        libiconv
    GIT_REPOSITORY https://github.com/GNOME/libxml2.git
    GIT_TAG 91586dc6742ab335682235120363f6e126eea5e2  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !result !test"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DLIBXML2_WITH_ZLIB=ON
        -DLIBXML2_WITH_ICONV=ON
        -DLIBXML2_WITH_LZMA=OFF
        -DLIBXML2_WITH_PYTHON=OFF
        -DLIBXML2_WITH_TESTS=OFF
        -DLIBXML2_WITH_HTTP=OFF
        -DLIBXML2_WITH_TREE=ON
        -DLIBXML2_WITH_THREADS=ON
        -DLIBXML2_WITH_THREAD_ALLOC=ON
        -DLIBXML2_WITH_PROGRAMS=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libxml2)
cleanup(libxml2 install)
