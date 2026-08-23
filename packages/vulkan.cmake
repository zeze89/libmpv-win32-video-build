ExternalProject_Add(vulkan
    DEPENDS vulkan-header
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Loader.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    # SABITLEME (2026-08-23, uc deneme sonrasi dogru bicim):
    #  - Ciplak GIT_TAG <etiket> klonu detached birakir ve force-update
    #    @{u} reset adiminda 'HEAD does not point to a branch' ile olur.
    #    Dogru mekanizma GIT_TAG main + GIT_RESET <sha>: HEAD dalda kalir,
    #    reset_head.sh sabit sha uzerine reset atar (llvm ve mbedtls ayni
    #    deseni kullaniyor ve arac zinciri bununla yesil).
    #  - Surum 1.3.275.0: yama git apply --check ile BU surumde temiz
    #    uygulaniyor, 1.4.357.0 uzerinde 'patch does not apply' veriyor.
    #  - Onceki 1.3.275.0 denemesi BOS commit cikti (replace tutmayinca
    #    ayni icerik geri gitti); artik her push sonrasi blob dogrulanir.
    GIT_TAG main
    GIT_RESET 00893b9a03e526aec2c5bf487521d16dfa435229
    # git am --3way YERINE git apply (2026-08-23). Uc yollu birlestirme
    # yamanin ON-GORUNTU blob'larini arar; klon --filter=tree:0 ile kismi
    # alindigi icin o nesneler yerelde yok ve git "sha1 information is
    # lacking or useless" diyor. git apply metinsel uygular, blob aramaz.
    # Yama once IZLENMEYEN dosyalar temizlenerek uygulanir: yamanin yarattigi
    # vulkan_own.pc.in git reset --hard'dan sag cikiyor (izlenmiyor) ve ikinci
    # uygulamada 'already exists in working directory' veriyordu (32641596322).
    # git am bu derde dusmezdi (commit'i reset soker) ama kismi klonda --3way
    # calismiyor; apply + on-temizlik ayni sonucu veriyor.
    PATCH_COMMAND ${EXEC} git clean -fdx -q
    COMMAND ${EXEC} git apply -v ${CMAKE_CURRENT_SOURCE_DIR}/vulkan-0001-cross-compile-static-linking-hacks.patch
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DVULKAN_HEADERS_INSTALL_DIR=${MINGW_INSTALL_PREFIX}
        -DBUILD_TESTS=OFF
        -DENABLE_WERROR=OFF
        -DUSE_MASM=OFF
        -DUSE_GAS=OFF
        -DBUILD_STATIC_LOADER=ON
        -DCMAKE_C_FLAGS='${CMAKE_C_FLAGS} -D__STDC_FORMAT_MACROS -DSTRSAFE_NO_DEPRECATE -Dparse_number=cjson_parse_number'
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS} -D__STDC_FORMAT_MACROS -fpermissive'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/loader/libvulkan.a ${MINGW_INSTALL_PREFIX}/lib/libvulkan.a
            COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/loader/vulkan_own.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/vulkan.pc
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(vulkan copy-wdk-headers
    DEPENDEES download
    DEPENDERS configure
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/toolchain/mingw-headers/d3dkmthk.h <SOURCE_DIR>/loader/d3dkmthk.h
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/toolchain/mingw-headers/d3dukmdt.h <SOURCE_DIR>/loader/d3dukmdt.h
    COMMENT "Copying extra mingw headers"
)

force_rebuild_git(vulkan)
cleanup(vulkan install)
