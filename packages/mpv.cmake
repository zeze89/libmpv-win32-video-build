ExternalProject_Add(mpv
    DEPENDS
        angle-headers
        ffmpeg
        fribidi
        lcms2
        libarchive
        libass
        libjpeg
        libpng
        uchardet
        mujs
        shaderc
        libplacebo
        spirv-cross
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    # SURUM SABITLENDI (Nightmare TV, 2026-08-22).
    # Stok tarifte GIT_TAG yok, yani HEAD cekiliyor ve bugun mpv 0.41
    # derlenir. Nightmare deposunda mpv 0.36'ya bagli OLCULMUS bir duzine
    # davranis var (ADVANCED_CONTROL kilidi, display-fps=0, report_swap
    # sayaci, paylasilan doku yarisi). Surum atlamak onlarin hepsini
    # gecersiz kilar. Bu commit uretimdeki libmpv-2.dll ile BIREBIR AYNI:
    # v0.36.0-403-g652a1dd907, dogrulandi.
    GIT_TAG 652a1dd90711839acdccc08004056d25514ef2d8
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --default-library=shared
        --prefer-static
        -Ddebug=true
        -Db_ndebug=true
        -Doptimization=3
        -Db_lto=true
        ${mpv_lto_mode}
        -Dgpl=false
        -Db_lto=true
        -Db_ndebug=true
        -Dlibmpv=true
        -Dpdf-build=enabled
        -Dlua=disabled
        -Djavascript=enabled
        -Duchardet=enabled
        -Dlcms2=enabled
        -Dopenal=disabled
        -Dspirv-cross=enabled
        -Dvulkan=enabled
        -Degl-angle=enabled
    BUILD_COMMAND ${EXEC} LTO_JOB=1 ninja -C <BINARY_DIR>
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv strip-binary
    DEPENDEES build
    ${mpv_add_debuglink}
    # Bu fork yalniz libmpv uretiyor (media_kit); CLI ikilileri yok ve strip
    # onlara takiliyordu (32648699580). Varsa soy, yoksa gec; dll zorunlu.
    COMMAND bash -c "[ ! -f <BINARY_DIR>/mpv.exe ] || ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.exe"
    COMMAND bash -c "[ ! -f <BINARY_DIR>/mpv.com ] || ${TARGET_ARCH}-strip -s <BINARY_DIR>/mpv.com"
    COMMAND ${EXEC} ${TARGET_ARCH}-strip -s <BINARY_DIR>/libmpv-2.dll
    COMMENT "Stripping mpv binaries"
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES strip-binary
    COMMAND bash -c "mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/mpv-package" 
    COMMAND bash -c "[ ! -f <BINARY_DIR>/mpv.exe ] || cp <BINARY_DIR>/mpv.exe ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.exe"
    COMMAND bash -c "mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/mpv-package" 
    COMMAND bash -c "[ ! -f <BINARY_DIR>/mpv.com ] || cp <BINARY_DIR>/mpv.com ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv.com"
    COMMAND bash -c "mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc" 
    COMMAND bash -c "[ ! -f <BINARY_DIR>/mpv.pdf ] || cp <BINARY_DIR>/mpv.pdf ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/doc/manual.pdf"
    COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/etc/fonts/fonts.conf   ${CMAKE_CURRENT_BINARY_DIR}/mpv-package/mpv/fonts.conf
    ${mpv_copy_debug}
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv-2.dll          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv-2.dll
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libmpv.dll.a          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libmpv.dll.a
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/client.h       ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/client.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/stream_cb.h    ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/stream_cb.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render.h       ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/render.h
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/libmpv/render_gl.h    ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/include/mpv/render_gl.h
    COMMENT "Copying mpv binaries and manual"
)

set(RENAME ${CMAKE_CURRENT_BINARY_DIR}/mpv-prefix/src/rename.sh)
file(WRITE ${RENAME}
"#!/bin/bash
cd $1
GIT=$(git rev-parse --short=7 HEAD)
mv $2 $2-git-\${GIT}")

ExternalProject_Add_Step(mpv copy-package-dir
    DEPENDEES copy-binary
    COMMAND chmod 755 ${RENAME}
    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-package ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}

    # Debug klasoru yalniz-libmpv derlemede olusmayabilir; varsa tasi.
    COMMAND bash -c "[ ! -d ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug ] || mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-debug ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}"
    COMMAND bash -c "[ ! -d ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE} ] || ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-debug-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}"

    COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMAND ${RENAME} <SOURCE_DIR> ${CMAKE_BINARY_DIR}/mpv-dev-${TARGET_CPU}${x86_64_LEVEL}-${BUILDDATE}
    COMMENT "Moving mpv package folder"
    LOG 1
)

force_rebuild_git(mpv)
force_meson_configure(mpv)
cleanup(mpv copy-package-dir)
