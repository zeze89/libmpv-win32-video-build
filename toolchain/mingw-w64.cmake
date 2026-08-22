ExternalProject_Add(mingw-w64
    GIT_REPOSITORY https://github.com/mingw-w64/mingw-w64.git
    # SURUM SABITLENDI (Nightmare TV, 2026-08-22). Burada hic GIT_TAG yoktu,
    # yani master UCU cekiliyordu. libunwind hatasinin diger yarisi burasi:
    # LLVM 17.0.6 ile ayni donemin mingw-w64'u v11.0.1 (2023-11). Iki tarafi
    # ayni doneme sabitlemek, ikisini de hareketli birakmaktan cok daha
    # tekrarlanabilir.
    GIT_TAG v11.0.1
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(mingw-w64)
get_property(MINGW_SRC TARGET mingw-w64 PROPERTY _EP_SOURCE_DIR)
