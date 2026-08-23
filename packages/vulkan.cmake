ExternalProject_Add(vulkan
    DEPENDS vulkan-header
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Loader.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    # SABITLENDI 2026-08-23. Onceki hali GIT_TAG main idi ve derleme
    # "error: sha1 information is lacking or useless (loader/CMakeLists.txt)"
    # ile patladi: Vulkan-Loader o dosyayi 2026-08-18'de degistirdi, bizim
    # vulkan-0001 yamamiz artik tutmuyor. Bu depo upstream'in eski bir
    # anlik goruntusu (upstream yamayi tamamen kaldirip vulkan_asm'e gecti,
    # o degisken bizde tanimli degil), o yuzden dosyayi senkronlamak yerine
    # surumu sabitliyoruz. 1.4.357.0 = 2026-07-17: yamanin tuttugu son
    # doneme ait ama GCC 16 icin yeterince yeni (eski surumler derlenmiyor).
    GIT_TAG vulkan-sdk-1.4.357.0
    # git am --3way YERINE git apply (2026-08-23). Uc yollu birlestirme
    # yamanin ON-GORUNTU blob'larini arar; klon --filter=tree:0 ile kismi
    # alindigi icin o nesneler yerelde yok ve git "sha1 information is
    # lacking or useless" diyor. git apply metinsel uygular, blob aramaz.
    PATCH_COMMAND ${EXEC} git apply -v ${CMAKE_CURRENT_SOURCE_DIR}/vulkan-0001-cross-compile-static-linking-hacks.patch
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
