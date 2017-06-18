#!/bin/bash

base="http://ftp.debian.org/debian"

[ $1 -eq 1 ] &&
for file in `dpkg -l | cut -d\  -sf3`
do
  echo $file
  apt-get download $file
done

[ $1 -eq 2 ] &&
for file in `find . -maxdepth 1 -name '*.deb' -type f`
do
  package=$(basename "${file/_*//}")
  for filepath in `apt-cache show $package | grep Filename | cut -d\  -sf2`
  do
    dirpath=$(dirname $filepath)
    mkdir -p $dirpath
    cp -v $file ${filepath}
  done
  rm $file
done

[ $1 -eq 3 ] && {
  dpkg-scanpackages pool/main /dev/null | gzip -9c > dists/stable/main/binary-amd64/Packages.gz 
  dpkg-scanpackages pool/contrib /dev/null | gzip -9c > dists/stable/contrib/binary-amd64/Packages.gz 
  dpkg-scanpackages pool/non-free /dev/null | gzip -9c > dists/stable/non-free/binary-amd64/Packages.gz 

  apt-ftparchive release pool/main > dists/stable/main/binary-amd64/Release
  apt-ftparchive release pool/contrib > dists/stable/contrib/binary-amd64/Release
  apt-ftparchive release pool/non-free > dists/stable/non-free/binary-amd64/Release
  apt-ftparchive release -c ../../../includes.binary/scripts/apt-release.conf dists/stable > dists/stable/Release

  gpg -a --yes --output dists/stable/Release.gpg --local-user 076AAEDF --detach-sign dists/stable/Release
  gpg -a --yes --clearsign --output dists/stable/InRelease --local-user 076AAEDF --detach-sign dists/stable/Release
}

# debootstrap --keyring ../../installer/chroot/manuel-io.gpg \
#             --components main,contrib,non-free \
#             --include linux-image-amd64,grub-pc,locales,cryptsetup,lvm2,zsh,vim \
#             --arch amd64 stable /mnt file:/../../packages/amd64
