execute_process(
    COMMAND mkdir -p cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/modules.tar.gz")
    execute_process(
        # SURUM SABITLENDI (Nightmare TV, 2026-08-22).
        #
        # Bu satir sablonlari CMake'in `release` DALINDAN, yani bugunun en
        # guncel surumunden cekiyordu; asagidaki satir ise
        # ExternalProject.cmake'i v3.26.4'e SABITLIYOR. Iki yari farkli
        # surumden geliyordu ve 2024'te uyumlulardi, bugun degil.
        #
        # Bugunun sablonunda gitclone.cmake.in:36 soyle:
        #     math(EXPR max_tries "1 + @git_clone_retries@")
        # `git_clone_retries` degiskenini BUGUNUN ExternalProject.cmake'i
        # tanimliyor. v3.26.4 onu bilmedigi icin yerine bos koyuluyor ve
        # uretilen betik `math(EXPR max_tries "1 + ")` oluyor:
        #     math cannot parse the expression: "1 + "
        # LLVM indirme adimi tam burada dusuyordu.
        COMMAND curl -sL https://gitlab.kitware.com/cmake/cmake/-/archive/v3.26.4/cmake-v3.26.4.tar.gz?path=Modules/ExternalProject -o modules.tar.gz
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    execute_process(
        COMMAND tar -C ${CMAKE_CURRENT_BINARY_DIR}/cmake --strip-components=1 -xf modules.tar.gz
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
endif()

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake")
    execute_process(
        COMMAND curl -sLO https://gitlab.kitware.com/cmake/cmake/-/raw/v3.26.4/Modules/ExternalProject.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules
    )
    execute_process(
        COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/packages/cmake-0001-ExternalProject-changes.patch
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake
    )
endif()

include(${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake)
