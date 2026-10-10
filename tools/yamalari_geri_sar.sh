#!/bin/bash
# Nightmare TV (2026-10-10): onbellekten YAMALI gelen kaynaklari temizler.
#
# Neden: depo onbellegi (src_packages) bir onceki kosunun `git am` ile
# yamalanmis kaynaklarini getiriyor; araci zinciri onbellegindeki damgalar
# silinmis ya da farkli oldugunda yama adimi yeniden kosuyor ve
# "sha1 information is lacking ... could not build fake ancestor" ile
# dusuyor (2026-10-10: once spirv-cross, sonra fontconfig).
#
# Ne yapar, `git am` kullanan HER paket icin:
#  1. Kaynakta HEAD'den geriye, yama dosyalarinin konu satirlariyla eslesen
#     commit'leri geri alir (kaynak hangi durumda gelirse gelsin yamasiz olur).
#  2. Paketin patch, configure, build, install ve done damgalarini siler:
#     yama KESIN yeniden uygulanir, yamasiz derleme riski yok.
# Bedel: bu paketler bastan derlenir.
#
# Kullanim (mpv clang is akisinin command girdisi): bash tools/yamalari_geri_sar.sh
set -u
BIT=${BIT:-x86_64}
for f in packages/*.cmake; do
  grep -q 'git am' "$f" || continue
  name=$(grep -o -m1 'ExternalProject_Add([^ ]*' "$f" | sed 's/ExternalProject_Add(//')
  [ -n "$name" ] || continue
  src="src_packages/$name"
  pat=$(grep -o -m1 'CMAKE_CURRENT_SOURCE_DIR}/[^ )]*\.patch' "$f" | sed 's/CMAKE_CURRENT_SOURCE_DIR}\///')
  if [ -d "$src/.git" ] && [ -n "$pat" ]; then
    git -C "$src" am --abort >/dev/null 2>&1
    # Konu satiri katlanabilir (devam satirlari bosluk ile baslar): baslik bitene kadar birlestir.
    konular=$(for p in packages/$pat; do [ -f "$p" ] && awk '/^Subject:/{s=$0; k=1; next} k && /^[ 	]/{sub(/^[ 	]+/," "); s=s $0; next} k{print s; exit}' "$p" | sed -E 's/^Subject: (\[PATCH[^]]*\] )?//'; done)
    geri=0
    while :; do
      s=$(git -C "$src" log -1 --format=%s 2>/dev/null) || break
      printf '%s\n' "$konular" | grep -qxF -- "$s" || break
      git -C "$src" reset -q --hard HEAD~1 || break
      geri=$((geri+1))
      [ $geri -gt 50 ] && break
    done
    git -C "$src" clean -fdxq >/dev/null 2>&1
    echo "[yama-sifirla] $name: $geri yama commit'i geri alindi, HEAD=$(git -C "$src" log -1 --format=%h)"
  else
    echo "[yama-sifirla] $name: kaynak yok ya da yama deseni bulunamadi ($src)"
  fi
  st="build_$BIT/packages/$name-prefix/src/$name-stamp"
  rm -f "$st/$name-patch" "$st/$name-configure" "$st/$name-build" "$st/$name-install" "$st/$name-done"
done
