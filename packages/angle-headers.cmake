ExternalProject_Add(angle-headers
    GIT_REPOSITORY https://github.com/google/angle.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    # Upstream ile ayni pin (2026-08-23): ANGLE guncel basliklari D3D9
    # sabitlerini kaldirdi, mpv 2023 ise bekliyor (context_angle.c:336
    # 'EGL_PLATFORM_ANGLE_TYPE_D3D9_ANGLE' tanimsiz, 32647187371). mpv'nin
    # kullandigi 10 ANGLE sabitinin hepsinin bu pinde var oldugu OLCULDU.
    GIT_RESET 0cb8023c01f92b29f3738ea7472d06f8f059ed84
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set include/EGL include/KHR"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/EGL ${MINGW_INSTALL_PREFIX}/include/EGL
            COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/KHR ${MINGW_INSTALL_PREFIX}/include/KHR
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(angle-headers)
cleanup(angle-headers install)
