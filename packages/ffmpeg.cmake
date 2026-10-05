ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        nvcodec-headers
        bzip2
        gmp
        lame
        libass
        libpng
        libsoxr
        libbs2b
        libwebp
        libzimg
        libmysofa
        fontconfig
        harfbuzz
        opus
        speex
        vorbis
        libxml2
        libplacebo
        shaderc
        vulkan-header
        spirv-headers
        dav1d
        mbedtls
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    # win-v7-fruc: FFmpeg master f0c2c00a62 (2026-10-04). fruc_vulkan (NVIDIA
    # optical flow ara kare) master'a d20bae84 (2026-08-30) ile girdi.
    # Eski pin: 705286a (win-v4..win-v6).
    GIT_TAG f0c2c00a629ee42875a3ded124e2f5722159068c
    UPDATE_COMMAND ""
    # Onbellekteki kaynak agaci eski pinde kalir (hash pininde reset_head.sh
    # HEAD'i oynatmaz). Pine acikca don, yoksa eski FFmpeg sessizce derlenir.
    PATCH_COMMAND ${EXEC} bash -c "git cat-file -e f0c2c00a629ee42875a3ded124e2f5722159068c 2>/dev/null || git fetch --filter=tree:0 origin f0c2c00a629ee42875a3ded124e2f5722159068c"
          COMMAND ${EXEC} git reset --hard -q f0c2c00a629ee42875a3ded124e2f5722159068c
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --target-exec=wine
        --pkg-config-flags=--static
        --enable-cross-compile

        --disable-gpl
        --disable-nonfree
        --enable-version3
        --enable-static
        --disable-shared
        # win-v7-fruc: Vulkan acik (fruc_vulkan icin). FFmpeg vulkan-1.dll'i
        # calisma aninda yukler; derlemede yalniz basliklar ve glslc gerekir.
        --enable-vulkan
        --disable-iconv
        --enable-stripping

        --disable-muxers
        --disable-decoders
        --disable-encoders
        --disable-demuxers
        --disable-parsers
        --disable-protocols
        --disable-filters
        --disable-doc
        # --disable-postproc: FFmpeg master libpostproc'u kaldirdi (2026-09-10, run 34419953653)
        --disable-programs
        --disable-gray
        --disable-swscale-alpha

        --enable-bsfs

        --enable-amf
        --enable-cuda
        --enable-nvdec
        --enable-nvenc
        --enable-cuvid
        --enable-dxva2
        --enable-libmfx
        --enable-d3d11va
        --enable-ffnvcodec

        --disable-vaapi
        --disable-vdpau
        --disable-bzlib
        --disable-libmfx
        --disable-libuavs3d
        --disable-linux-perf
        --disable-videotoolbox
        --disable-audiotoolbox

        --enable-small
        --enable-hwaccels
        --enable-optimizations
        --enable-runtime-cpudetect

        --enable-mbedtls

        --disable-libjxl
        --enable-libdav1d
        --enable-libplacebo
        # libvpl (Intel QSV) cikarildi: clang 22 ile derlenmiyor, Nightmare d3d11va kullanir (2026-09-10)
        --enable-libbs2b
        --enable-libwebp
        --enable-libzimg
        --enable-libxml2
        --enable-libsoxr
        --enable-libspeex
        --enable-libmysofa
        # --enable-libshaderc: master configure'da yok, cikarildi (2026-09-10)
        --enable-libfribidi
        --enable-libfreetype

        --enable-avutil
        --enable-avcodec
        --enable-avfilter
        --enable-avformat
        --enable-avdevice
        --enable-swscale
        --enable-swresample

        --enable-decoder=flv
        --enable-decoder=h263
        --enable-decoder=h263i
        --enable-decoder=h263p
        --enable-decoder=h264*
        --enable-decoder=mpeg1video
        --enable-decoder=mpeg2*
        --enable-decoder=mpeg4*
        --enable-decoder=vp6
        --enable-decoder=vp6a
        --enable-decoder=vp6f
        --enable-decoder=vp8*
        --enable-decoder=vp9*
        --enable-decoder=hevc*
        --enable-decoder=av1*
        --enable-decoder=libdav1d
        --enable-decoder=theora
        --enable-decoder=msmpeg*
        --enable-decoder=mjpeg*
        --enable-decoder=wmv*

        --enable-decoder=aac*
        --enable-decoder=ac3
        --enable-decoder=alac
        --enable-decoder=als
        --enable-decoder=ape
        --enable-decoder=atrac*
        --enable-decoder=eac3
        --enable-decoder=flac
        --enable-decoder=gsm*
        --enable-decoder=mp1*
        --enable-decoder=mp2*
        --enable-decoder=mp3*
        --enable-decoder=mpc*
        --enable-decoder=opus
        --enable-decoder=ra*
        --enable-decoder=ralf
        --enable-decoder=shorten
        --enable-decoder=tak
        --enable-decoder=tta
        --enable-decoder=vorbis
        --enable-decoder=wavpack
        --enable-decoder=wma*
        --enable-decoder=pcm*
        --enable-decoder=dsd*
        --enable-decoder=dca

        --enable-decoder=ssa
        --enable-decoder=ass
        --enable-decoder=dvbsub
        --enable-decoder=dvdsub
        --enable-decoder=srt
        --enable-decoder=stl
        --enable-decoder=subrip
        --enable-decoder=subviewer
        --enable-decoder=subviewer1
        --enable-decoder=text
        --enable-decoder=vplayer
        --enable-decoder=webvtt
        --enable-decoder=movtext

        --enable-decoder=mjpeg
        --enable-decoder=ljpeg
        --enable-decoder=jpegls
        --enable-decoder=jpeg2000
        --enable-decoder=png
        --enable-decoder=gif
        --enable-decoder=bmp
        --enable-decoder=tiff
        --enable-decoder=webp
        --enable-decoder=jpegls

        --enable-demuxer=concat
        --enable-demuxer=data
        --enable-demuxer=flv
        --enable-demuxer=hls
        --enable-demuxer=latm
        --enable-demuxer=live_flv
        --enable-demuxer=loas
        --enable-demuxer=m4v
        --enable-demuxer=mov
        --enable-demuxer=mpegps
        --enable-demuxer=mpegts
        --enable-demuxer=mpegvideo
        --enable-demuxer=hevc
        --enable-demuxer=rtsp
        --enable-demuxer=mpeg4
        --enable-demuxer=mjpeg*
        --enable-demuxer=avi
        --enable-demuxer=av1
        --enable-demuxer=matroska
        --enable-demuxer=dash
        --enable-demuxer=webm_dash_manifest

        --enable-demuxer=aac
        --enable-demuxer=ac3
        --enable-demuxer=aiff
        --enable-demuxer=ape
        --enable-demuxer=asf
        --enable-demuxer=au
        --enable-demuxer=avi
        --enable-demuxer=flac
        --enable-demuxer=flv
        --enable-demuxer=matroska
        --enable-demuxer=mov
        --enable-demuxer=m4v
        --enable-demuxer=mp3
        --enable-demuxer=mpc*
        --enable-demuxer=ogg
        --enable-demuxer=pcm*
        --enable-demuxer=rm
        --enable-demuxer=shorten
        --enable-demuxer=tak
        --enable-demuxer=tta
        --enable-demuxer=wav
        --enable-demuxer=wv
        --enable-demuxer=xwma
        --enable-demuxer=dsf
        --enable-demuxer=truehd
        --enable-demuxer=dts
        --enable-demuxer=dtshd

        --enable-demuxer=ass
        --enable-demuxer=srt
        --enable-demuxer=stl
        --enable-demuxer=webvtt
        --enable-demuxer=subviewer
        --enable-demuxer=subviewer1
        --enable-demuxer=vplayer

        --enable-parser=h263
        --enable-parser=h264
        --enable-parser=hevc
        --enable-parser=mpeg4
        --enable-parser=mpeg4video
        --enable-parser=mpegvideo

        --enable-parser=aac*
        --enable-parser=ac3
        --enable-parser=cook
        --enable-parser=flac
        --enable-parser=gsm
        --enable-parser=mpegaudio
        --enable-parser=tak
        --enable-parser=vorbis
        --enable-parser=dca

        --enable-filter=overlay
        --enable-filter=equalizer
        # --- Nightmare TV eklemeleri (2026-08-22) ---
        # Ayristirici: TR canli kanallari 1080i25 geliyor ve stok derlemede
        # HICBIR ayristirici yok, mpv "Creating filter 'yadif' failed" deyip
        # ham taramali kareyi basiyordu. Olculdu: tam libmpv ile cikis
        # 25 -> 50 fps, tarak disi kayboldu.
        # Ikisi de LGPL 2.1+, yani --disable-gpl / -Dgpl=false duruşu bozulmaz.
        --enable-filter=yadif
        --enable-filter=bwdif
        # ALTYAPI FILTRELERI — BUNLAR OLMADAN YUKARIDAKI IKISI CALISMAZ.
        #
        # 2026-08-23te olculdu, 2026-09-21de AYNI ARIZA GERI GELDI.
        # yadif/bwdif tek basina YETMIYOR: lavfi grafigi kurulurken bicim
        # donusumu icin scale/format gerekiyor. Yoklugunda mpv soyle der:
        #   ffmpeg: 'scale' filter not present, cannot convert formats.
        #   ffmpeg: src: nv12   (dxva2 donanim cozumunun cikisi)
        #   lavfi: failed to configure the filter graph
        #   vf: Disabling filter bwdif.00 because it has failed.
        # Yani ayar duruyor, filtre ikilide GORUNUYOR, grafik hic kurulmuyor.
        # Belirti: kayan yazida yatay ikizlenme (tarak), vfps=25 sabit.
        #
        # KURAL: ikilide filtre adinin gecmesi kanit degildir. Yeni bir
        # win-vN dali acilirken bu blok TASINMAK ZORUNDA; win-v4 upstreamden
        # sifirdan dallandi, blok tasinmadi ve ariza aynen geri geldi.
        --enable-filter=scale
        --enable-filter=format
        --enable-filter=null
        --enable-filter=copy
        --enable-filter=setpts
        --enable-filter=aformat
        --enable-filter=aresample
        --enable-filter=anull
        --enable-filter=asetpts
        # GORUNTU FILTRELERI: dusuk bit hizli IPTVde gurultu ve bantlanma
        # var. atadenoise = uyarlamali zamansal denoise (ucuz, detay korur),
        # unsharp = keskinlestirme, gradfun = bantlanma.
        # hqdn3d BILEREK YOK: ffmpegde GPL, bizim derleme --disable-gpl;
        # beyaz listeye yazmak sessizce etkisiz kalir.
        # nlmeans BILEREK YOK: kalitesi iyi ama 1080p50 canlida yetismez.
        --enable-filter=atadenoise
        --enable-filter=unsharp
        --enable-filter=gradfun
        # SES FILTRELERI: iki ayar bunlar olmadan olu kaliyor.
        #  - "Akilli ses > Gece" af=lavfi=[dynaudnorm=...] yaziyor,
        #    mpv "No such filter: 'dynaudnorm'" deyip grafigi kuramiyor.
        #  - "Kanal Sesi Dengeleyici" af=loudnorm=... yaziyor,
        #    mpv "Option af: loudnorm doesn't exist" ile reddediyor.
        # Ikisi de LGPL 2.1+ (af_dynaudnorm.c / af_loudnorm.c kontrol edildi).
        --enable-filter=dynaudnorm
        --enable-filter=loudnorm
        # Muxer: stok derleme --disable-muxers ve tek bir --enable-muxer= yok.
        # spdif olmadan `audio-spdif` (Ses Passthrough) ses aygitini HIC
        # acmiyor ve oynatma sessizce donuyor. mpegts/matroska olmadan
        # `stream-record` "Output format not found" deyip dosya uretmiyor.
        # RTX ARA KARE (win-v7-fruc, laboratuvar): NVIDIA optical flow ile
        # gercek zamanli kare hizi artirma. hwupload/hwdownload sistem
        # bellegindeki kareyi (d3d11va-copy) Vulkan'a tasir ve geri alir.
        # Vulkan cihazi mpv f_lavfi yamasiyla (mpv-0002) acilir.
        --enable-filter=hwupload
        --enable-filter=hwdownload
        --enable-filter=fruc_vulkan
        --enable-muxer=spdif
        --enable-muxer=mpegts
        --enable-muxer=matroska

        --enable-protocol=async
        --enable-protocol=cache
        --enable-protocol=crypto
        --enable-protocol=data
        --enable-protocol=ffrtmphttp
        --enable-protocol=file
        --enable-protocol=ftp
        --enable-protocol=hls
        --enable-protocol=http
        --enable-protocol=httpproxy
        --enable-protocol=https
        --enable-protocol=pipe
        --enable-protocol=rtmp
        --enable-protocol=rtmps
        --enable-protocol=rtmpt
        --enable-protocol=rtmpts
        --enable-protocol=rtp
        --enable-protocol=subfile
        --enable-protocol=tcp
        --enable-protocol=tls
        --enable-protocol=srt

        --enable-encoder=mjpeg
        --enable-encoder=ljpeg
        --enable-encoder=jpegls
        --enable-encoder=jpeg2000
        --enable-encoder=png
        --enable-encoder=jpegls

        --enable-network

        ${ffmpeg_lto}
        --extra-cflags='-Wno-error=int-conversion'
        "--extra-libs='${ffmpeg_extra_libs}'" # -lstdc++ / -lc++ needs by libjxl and shaderc
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
