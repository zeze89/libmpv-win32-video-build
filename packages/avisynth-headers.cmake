ExternalProject_Add(avisynth-headers
    GIT_REPOSITORY https://github.com/AviSynth/AviSynthPlus.git
    GIT_TAG 5c82777b374bdef16e13007a11e77d735ac1e4eb  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !distrib"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    GIT_RESET 21fdc997f9724b994896ba5520ddf64d677976b3
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DHEADERS_ONLY=ON
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR> VersionGen
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)
force_rebuild_git(avisynth-headers)
cleanup(avisynth-headers install)
