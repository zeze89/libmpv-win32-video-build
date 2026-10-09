ExternalProject_Add(graphengine
    GIT_REPOSITORY https://github.com/sekrit-twc/graphengine.git
    GIT_TAG 91c6af4c795c5396d8b974f24b4d2e2ecca04e2d  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) varsayilan dal
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(graphengine)
cleanup(graphengine install)
