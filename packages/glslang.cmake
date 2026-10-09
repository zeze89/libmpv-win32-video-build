ExternalProject_Add(glslang
    GIT_REPOSITORY https://github.com/KhronosGroup/glslang.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !Test"
    GIT_REMOTE_NAME origin
    GIT_TAG 5494791363451eb51b959544728c8d204b567fd2  # win-v6-pin: win-v5 yayin derlemesi (run 35667606953, 2026-09-21 23:28 UTC) main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(glslang)
cleanup(glslang install)
