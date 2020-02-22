#!/bin/bash
VER=80.0.3987.106-1
PKG=ungoogled-chromium-$VER-x86_64.pkg.tar.xz
SIG=$PKG.sig

gpg -o $SIG --detach-sign $PKG
repo-add -s -R jk-aur.db.tar.gz $PKG

rsync -e ssh -Phazz jk-aur* $SIG lyra:/home/jk/Repo/
