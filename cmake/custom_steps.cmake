function(cleanup _name _last_step)
    get_property(_build_in_source TARGET ${_name} PROPERTY _EP_BUILD_IN_SOURCE)
    get_property(_git_repository TARGET ${_name} PROPERTY _EP_GIT_REPOSITORY)
    get_property(_url TARGET ${_name} PROPERTY _EP_URL)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    get_property(git_remote_name TARGET ${_name} PROPERTY _EP_GIT_REMOTE_NAME)
    get_property(stamp_dir TARGET ${_name} PROPERTY _EP_STAMP_DIR)
    get_property(source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)

    if("${git_remote_name}" STREQUAL "" AND NOT "${git_tag}" STREQUAL "")
        # GIT_REMOTE_NAME is not set when commit hash is specified
        set(git_tag "")
    else()
        set(git_tag "@{u}")
    endif()

    if(_git_repository)
        if(_build_in_source)
            set(remove_cmd "git -C <SOURCE_DIR> clean -dfx")
        else()
            set(remove_cmd "rm -rf <BINARY_DIR>/* && git -C <SOURCE_DIR> clean -df")
        endif()
        # KAYNAK DIZINI HENUZ KLONLANMAMISSA ATLA (Nightmare TV, 2026-08-22).
        #
        # Ucu de `git -C <SOURCE_DIR> ...` calistiriyor. Paket henuz
        # indirilmemisse orada .git yoktur ve git YUKARI YURUYUP calisma
        # alaninin kendi deposunu bulur. Iki sonucu var:
        #  1. ninja bu adimlari paralel kosturdugu icin hepsi ayni
        #     .git/index.lock dosyasina carpiyor.
        #  2. Daha kotusu: `git restore .` YANLIS depoda calisir ve
        #     tarife uyguladigimiz yamalari geri alabilir.
        # Klonlanmamis paketin sifirlanacak bir seyi zaten yok.
        set(COMMAND_FORCE_UPDATE COMMAND bash -c "[ -e <SOURCE_DIR>/.git ] || exit 0; git -C <SOURCE_DIR> am --abort 2> /dev/null || true"
                                 COMMAND bash -c "[ -e <SOURCE_DIR>/.git ] || exit 0; exec ${stamp_dir}/reset_head.sh"
                                 COMMAND bash -c "[ -e <SOURCE_DIR>/.git ] || exit 0; git -C <SOURCE_DIR> restore .")
    endif()

    # <STAMP_DIR> doesn't resolve into full path, so <LOG_DIR> is used instead since its same folder.
    ExternalProject_Add_Step(${_name} fullclean
        COMMAND ${EXEC} find <LOG_DIR> -type f " ! -iname '*.cmake' " -size 0c -delete # remove 0 byte files which are stamp files
        ${COMMAND_FORCE_UPDATE}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting all stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} liteclean
        COMMAND ${EXEC} rm -f <LOG_DIR>/${_name}-build
                              <LOG_DIR>/${_name}-install
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting build, install stamp files of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} postremovebuild
        DEPENDEES ${_last_step}
        COMMAND ${EXEC} ${remove_cmd}
        ${COMMAND_FORCE_UPDATE}
        LOG 1
        COMMENT "Deleting build directory of ${_name} package after install"
    )

    ExternalProject_Add_Step(${_name} removebuild
        DEPENDEES fullclean
        COMMAND ${EXEC} ${remove_cmd}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting build directory of ${_name} package"
    )

    ExternalProject_Add_Step(${_name} removeprefix
        COMMAND ${EXEC} rm -rf <INSTALL_DIR> ${source_dir}
        COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target rebuild_cache
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting everything about ${_name} package"
    )
    ExternalProject_Add_StepTargets(${_name} fullclean liteclean removeprefix removebuild)
endfunction()

function(force_rebuild_git _name)
    get_property(git_tag TARGET ${_name} PROPERTY _EP_GIT_TAG)
    get_property(git_reset TARGET ${_name} PROPERTY _EP_GIT_RESET)
    get_property(git_remote_name TARGET ${_name} PROPERTY _EP_GIT_REMOTE_NAME)
    get_property(stamp_dir TARGET ${_name} PROPERTY _EP_STAMP_DIR)
    get_property(source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)

    if("${git_remote_name}" STREQUAL "" AND NOT "${git_tag}" STREQUAL "")
        # GIT_REMOTE_NAME is not set when commit hash is specified
        set(reset "")
    elseif(NOT "${git_reset}" STREQUAL "")
        set(reset "${git_reset}")
    else()
        set(reset "@{u}") # eg: origin/master
    endif()

file(WRITE ${stamp_dir}/reset_head.sh
"#!/bin/bash
set -e
if [[ ! -f \"${stamp_dir}/${_name}-patch\"  || \"${stamp_dir}/${_name}-download\" -nt \"${stamp_dir}/${_name}-patch\" || ! -f \"${stamp_dir}/HEAD\" || \"$(cat ${stamp_dir}/HEAD)\" != \"$(git -C ${source_dir} rev-parse @{u})\" ]]; then
    git -C ${source_dir} reset --hard ${reset} -q
    # Damga silme artik GIT_RESET durumunda da yapiliyor (2026-08-23):
    # reset --hard uygulanmis YAMAYI geri alir; damgalar kalinca yama adimi
    # atlanir ve yamasiz agac derlenir. vulkan-install tam boyle dustu
    # (32641388124: libvulkan.a uretilmedi). Bedeli sabitli paketin her
    # kosuda yeniden derlenmesi; dogruluk icin kabul edildi.
    find \"${stamp_dir}\" -type f  ! -iname '*.cmake' -size 0c -delete
    echo \"Removing ${_name} stamp files.\"
    git -C ${source_dir} rev-parse HEAD > ${stamp_dir}/HEAD
else
    git -C ${source_dir} reset --hard -q
fi")
file(CHMOD ${stamp_dir}/reset_head.sh 
PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

    ExternalProject_Add_Step(${_name} force-update
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        WORKING_DIRECTORY <SOURCE_DIR>
        # .git yoksa git buradan YUKARI yuruyup depo kokundeki .git dizinini
        # bulur; 22 paralel adim index.lock uzerinde carpisti (32638665172).
        # Kaynak bos ama download damgasi gecerliyse damgalar silinir ki ana
        # derleme paketi yeniden klonlasin (fast_float/libdovi boyle iyilesir).
        # fetch || true: upstream c24abb677, gecici ag hatasi isi oldurmesin.
        # DIKKAT: CMake COMMAND icinde ";" liste ayracidir ve komutu boler
        # (kosu 32640619766 boyle oldu: acik kalan { soz dizimi hatasi).
        # Bu yuzden asagidaki uc satir yalniz && ve || kullanir. Calisma
        # dizini <SOURCE_DIR> oldugu icin .git goreli yazilir.
        COMMAND bash -c "[ ! -e .git ] || git am --abort 2> /dev/null || true"
        COMMAND bash -c "[ ! -e .git ] || git fetch --filter=tree:0 --no-recurse-submodules || true"
        COMMAND bash -c "[ -e .git ] && exec ${stamp_dir}/reset_head.sh || rm -f ${stamp_dir}/${_name}-download ${stamp_dir}/${_name}-gitclone-lastrun.txt"
    )
    ExternalProject_Add_StepTargets(${_name} force-update)

    ExternalProject_Add_Step(${_name} write-head
        DEPENDERS patch
        INDEPENDENT TRUE
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND bash -c "git rev-parse HEAD > ${stamp_dir}/HEAD"
        LOG 1
    )

    if(EXISTS ${source_dir}/.git)
        ExternalProject_Add_Step(${_name} check-git
            DEPENDERS download
            INDEPENDENT TRUE
            WORKING_DIRECTORY ${stamp_dir}
            COMMAND ${CMAKE_COMMAND} -E touch <INSTALL_DIR>/src/${_name}-stamp/${_name}-download
            COMMAND ${CMAKE_COMMAND} -E copy ${_name}-gitinfo.txt ${_name}-gitclone-lastrun.txt
            LOG 1
        )
    else()
        execute_process(
            WORKING_DIRECTORY ${stamp_dir}
            COMMAND ${EXEC} rm ${_name}-gitclone-lastrun.txt
            ERROR_QUIET
        )
    endif()
endfunction()

function(force_rebuild_svn _name)
    ExternalProject_Add_Step(${_name} force-update
        DEPENDEES download update
        DEPENDERS patch build install
        COMMAND svn revert -R .
        COMMAND svn up
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

function(force_rebuild_hg _name)
    ExternalProject_Add_Step(${_name} force-update
        DEPENDEES download update
        DEPENDERS patch build install
        COMMAND hg --config "extensions.purge=" purge --all
        COMMAND hg update -C
        WORKING_DIRECTORY <SOURCE_DIR>
        LOG 1
    )
endfunction()

function(force_meson_configure _name)
    ExternalProject_Add_Step(${_name} force-meson-configure
        DEPENDERS configure
        COMMAND ${EXEC} rm -rf <BINARY_DIR>/meson-*
        LOG 1
    )
endfunction()
