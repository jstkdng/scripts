#!/bin/bash
VER=81.0.4044.129-2
PKG=ungoogled-chromium-$VER-x86_64.pkg.tar.xz
SIG=$PKG.sig

echo "Signing package..."
rm -f $SIG
gpg -o $SIG --detach-sign $PKG
echo "Adding to repository files..."
repo-add -q -s -R jk-aur.db.tar.gz $PKG
echo "Sending repository files to server..."
rsync -q -e ssh -Phazz jk-aur* $SIG lyra:/home/jk/Repo/

echo "Downloading package on server..."
ssh lyra "zsh -s $PKG" <<"ENDSSH"
    PKG=$1
    URL="https://download.opensuse.org/repositories/home:/justkidding:/arch/standard/x86_64/${PKG}"
    cd /home/jk/Repo/
    wget -q $URL
    cd /srv/http/repo/arch/x86_64/
    rm -f *
    mv /home/jk/Repo/* .
ENDSSH
echo "Done."
