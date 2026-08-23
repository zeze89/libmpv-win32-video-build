# GCC 14+ ESKI C KODUNU REDDEDIYOR (Nightmare TV, 2026-08-23).
#
# Derleme `ghcr.io/shinchiro/archlinux:latest` konteynerinde kosuyor, yani
# yuvarlanan bir imaj: bugun GCC 16. `runs-on` degistirmek bunu ETKILEMIYOR,
# derleyici konteynerin icinde.
#
# gendef mingw-w64'un HOST tarafi bir araci ve v11.0.1 kaynaginda GCC 14'ten
# beri varsayilan olarak HATA sayilan kaliplar var:
#   gendef.c:148: error: assignment discards 'const' qualifier
# Ayni satirlar eski derleyicide UYARIydi; mingw-w64'te bir sey degismedi,
# konteynerin derleyicisi degisti.
#
# Surumu yukseltmek yerine bu uc taniyi eski davranisina donduruyoruz:
# mingw-w64 surumu LLVM 17.0.6 ile eslesmek icin bilerek sabit ve oynatmak
# libunwind uyumsuzlugunu geri getirir.
set(GENDEF_CFLAGS "-Wno-error=discarded-qualifiers -Wno-error=incompatible-pointer-types -Wno-error=int-conversion")

ExternalProject_Add(gendef
    DEPENDS
        mingw-w64
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    SOURCE_DIR ${MINGW_SRC}
    CONFIGURE_COMMAND ${EXEC} CONF=1 "CFLAGS=${GENDEF_CFLAGS}" <SOURCE_DIR>/mingw-w64-tools/gendef/configure
        --prefix=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install-strip
    LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(gendef install)
