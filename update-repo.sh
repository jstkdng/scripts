#!/bin/bash
set -e

declare -a URLS=()
declare -a PKGS=()
declare -a SIGS=()
declare -A VARIANTS=(
    [ungoogled-chromium]=83.0.4103.61-1
    [ungoogled-chromium-ozone]=83.0.4103.61-1
    [ungoogled-chromium-git]=83.0.4103.61.1.r0.gc732887-1
)

echo "Downloading and signing packages"
for KEY in "${!VARIANTS[@]}"
do
    PKG="${KEY}-${VARIANTS[$KEY]}-x86_64.pkg.tar.xz"
    URL="https://download.opensuse.org/repositories/home:/justkidding:/arch/standard/x86_64/${PKG}"
    SIG=$PKG.sig
    URLS+=($URL)
    PKGS+=($PKG)
    SIGS+=($SIG)
    if [ ! -f $PKG ]; then
        wget -q $URL
    fi
    gpg -o $SIG --detach-sign $PKG
done

echo "Adding binaries to repo file"
repo-add -q -s -R jk-aur.db.tar.gz ${PKGS[@]}
echo "Sending files to server"
rsync -q -e ssh -Phazz jk-aur* ${SIGS[@]} lyra:/home/jk/Repo/

echo "Cleaning up local files"
rm -f ${SIGS[@]}

echo "Downloading package on server..."
ssh lyra "zsh -s ${URLS[@]}" <<"ENDSSH"
    cd /home/jk/Repo
    wget -q $@
    cd /srv/http/repo/arch/x86_64/
    rm -f *
    mv /home/jk/Repo/* .
ENDSSH
echo "Done."
