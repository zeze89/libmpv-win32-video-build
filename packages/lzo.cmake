ExternalProject_Add(lzo
    # AYNA DEGISTI (Nightmare TV, 2026-08-22). fossies.org artik HTTP
    # hatasi veriyor ve indirme dusuyor. `ninja download` ilk hatada
    # duruyor, yani lzo'dan SONRAKI paketlerin hicbiri inmiyor; sonra
    # guncelleme asamasi olmayan kaynaklarda calisip git'i yukari
    # yuruttuyor ve calisma alaninin .git/index.lock dosyasina
    # carptiriyordu. Yani tek bir olu ayna butun kosuyu dusuruyordu.
    # Ustteki adres lzo'nun RESMI kaynagi; indirilip SHA1'i tek tek
    # dogrulandi, asagidaki hash ile birebir ayni dosya.
    URL "https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
        "https://fossies.org/linux/misc/lzo-2.10.tar.gz"
    URL_HASH SHA1=4924676a9bae5db58ef129dc1cebce3baa3c4b5d
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(lzo install)
